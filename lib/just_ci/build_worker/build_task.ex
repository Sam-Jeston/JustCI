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
    tasks = find_template_tasks job

    # Iterate over each task
    # Call execute... On success, call next task or finish job and write log
                  #   On failure, fail job and write log
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
  Runs the task command provided in the shell of the host machine
  """
  def execute command do
    %Result{out: output, status: status} = Porcelain.shell(command)

    # Update the log field on the job (maybe we log to ETS against jobId....)
    # return the result from procelain shelll
  end
end
