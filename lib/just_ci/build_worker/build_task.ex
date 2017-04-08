defmodule JustCi.BuildTask do
  alias JustCi.Repo
  alias JustCi.Job
  alias Porcelain.Result
  import Ecto.Query

  @doc """
  Starts a build task.
  Returns {:ok, job: job}
  """
  def run job do
    # TODO: The first step on any repository needs to be a git clone of the
    # repo in question. Clearly some SSH mechanisms will be required, and the use
    # of a UUID to store the code in

    tasks = find_template_tasks job

    Enum.each(tasks, fn t ->
      {status, output} = Task.async(JustCi.BuildTask, :execute, t.command)
    end)
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
  def clone_repository do
    # Need to store the private key in a table somewhere
  end

  # We will use recursion with guards to handle 0 code
  def execute(previous_status, tasks, job) when previous_status == 0 do
    [ current_task | remaining_tasks ] = tasks
    %Result{out: output, status: status} = Porcelain.shell(current_task.command)

    store_log(output, job.id)

    case Enum.length remaining_tasks do
      0 -> finish_job(status, job)
      _ -> execute(status, remaining_tasks, job)
    end
  end

  # This method will match when the previous status is not equal to 0
  def execute(previous_status, tasks, job) do
    finish_job(previous_status, job)
  end

  @doc """
  Stores a single task commands log result against a job
  """
  def store_log(output, job_id) do
  end

  @doc """
  Finish job will handle the aggregation and and cleanup of the job
  """
  def finish_job(exit_status, job) do
  end

  @doc """
  Returns the log entries for a job, deletes them and aggregates the result
  into the job entry
  """
  def aggregate_log do
  end

  @doc """
  Removes the job folder
  """
  def job_cleanup do
  end
end
