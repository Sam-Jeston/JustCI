defmodule JustCi.BuildTask do
  alias JustCi.Repo
  alias JustCi.Job
  import Ecto.Query

  @doc """
  Starts a build task.
  Returns {:ok, job: job}
  """
  def run do

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

    IO.inspect loaded_job.build.template.tasks
    loaded_job.build.template.tasks
  end

  @doc """
  Runs the task command provided in the shell of the host machine
  """
  def execute do

  end
end
