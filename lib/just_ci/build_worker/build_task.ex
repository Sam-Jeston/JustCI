defmodule JustCi.BuildTask do
  alias JustCi.Repo
  alias JustCi.Job
  alias JustCi.Build
  alias JustCi.ThirdPartyKey
  alias JustCi.JobLog
  alias JustCi.GithubStatus
  alias Porcelain.Result
  import Ecto.Query

  @doc """
  Starts a build task.
  """
  def run job do
    tasks = find_template_tasks job
    Task.start(JustCi.BuildTask, :clone_repository, [job, tasks])
  end

  @doc """
  Finds the tasks of a template and returns them in order
  """
  def find_template_tasks job do
    job_id = job.id

    loaded_job = Job
    |> where([j], j.id == ^job_id)
    |> join(:inner, [j], build in assoc(j, :build))
    |> join(:inner, [j, build], template in assoc(build, :template))
    |> join(:inner, [j, build, template], tasks in assoc(template, :tasks))
    |> order_by([j, build, template, tasks], [asc: tasks.order])
    |> preload([j, build, template, tasks], [build: {build, template: {template, tasks: tasks}}])
    |> Repo.one

    loaded_job.build.template.tasks
  end

  @doc """
  Stores a single task commands log result against a job
  """
  # We should be able to handle other providers here, through guards for BB etc
  def clone_repository(job, tasks) do
    job_path = "~/Builds/" <> Integer.to_string job.id
    key_path = job_path <> "/ssh-key"

    build = Repo.get(Build, job.build_id)
    cloner = "git@github.com:" <> job.owner <> "/" <> build.repo <>".git"

    Porcelain.shell("mkdir -p " <> job_path)

    key = ThirdPartyKey
    |> where([k], k.entity == "github")
    |> Repo.one

    #############################
    # TODO: These steps are right, but getting passphrase prompt on os x
    # Porcelain.shell("touch " <> key_path)
    # Porcelain.shell("chmod 400 " <> key_path)
    # Porcelain.shell("eval \"$(ssh-agent -s)\"")
    # Porcelain.shell("ssh-add " <> key_path)

    # Only clone if we aren't in local mode
    if !System.get_env("LOCAL_MODE") do
      Porcelain.shell("cd " <> job_path <> " && git clone " <> cloner)
    end

    execute(0, tasks, job, job_path <> "/" <> build.repo)
  end

  # We will use recursion with guards to handle 0 code
  def execute(previous_status, tasks, job, target_path) when previous_status == 0 do
    [ current_task | remaining_tasks ] = tasks
    IO.inspect target_path
    IO.inspect "cd " <> target_path <> "; " <> current_task.command <> ";"
    cmd = "cd " <> target_path <> "; " <> current_task.command
    %Result{out: output, status: status} = Porcelain.shell(cmd)

    store_log(current_task.command, output, job.id)

    case length remaining_tasks do
      0 -> finish_job(status, job, target_path)
      _ -> execute(status, remaining_tasks, job, target_path)
    end
  end

  # This method will match when the previous status is not equal to 0
  def execute(previous_status, tasks, job, target_path) do
    finish_job(previous_status, job, target_path)
  end

  @doc """
  Stores a single task commands log result against a job
  """
  def store_log(command, output, job_id) do
    log = command <> ":\n" <> output
    changeset = JobLog.changeset(%JobLog{}, %{
      job_id: job_id,
      entry: log
    })

    # Ship the log to any clients listening
    JustCi.Endpoint.broadcast("ci:lobby", "log_event", %{log: log})

    case Repo.insert changeset do
      {:ok, changeset} ->
        changeset
      {:error, changeset} ->
        raise RuntimeError, message: "There was a problem storing a jobs log"
    end
  end

  @doc """
  Finish job will handle the aggregation and and cleanup of the job
  """
  def finish_job(exit_status, job, target_path) do
    status =
      case exit_status do
        0 -> "passed"
        _ -> "failed"
      end

    log = aggregate_log(job.id)

    changeset = Job.changeset(job, %{
      status: status,
      log: log
    })

    remove_job_logs(job.id)

    case Repo.update changeset do
      {:ok, changeset} ->
        changeset
      {:error, changeset} ->
        raise RuntimeError, message: "There was a problem finishing the job"
    end

    job_cleanup(target_path)

    case exit_status do
      0 -> GithubStatus.set_passed_status(job.build.repo, job.owner, job.sha)
      _ -> GithubStatus.set_failed_status(job.build.repo, job.owner, job.sha)
    end
  end

  @doc """
  Returns the log entries for a job, deletes them and aggregates the result
  into the job entry
  """
  def aggregate_log(job_id) do
    log_entries = JobLog
    |> where([j], j.job_id == ^job_id)
    |> order_by([j], [asc: j.id])
    |> Repo.all

    Enum.reduce(log_entries, "", fn(l, acc) -> acc <> l.entry end)
  end

  @doc """
  Removes all logs associated with a job
  """
  def remove_job_logs(job_id) do
    JobLog
    |> where([j], j.job_id == ^job_id)
    |> Repo.delete_all
  end

  @doc """
  Removes the job contents of the folder
  """
  def job_cleanup(target_path) do
    # TODO: Update this cleanup to remove the build folder as well
    Porcelain.shell("rm -rf " <> target_path)
  end
end
