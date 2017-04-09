defmodule JustCi.BuildWorker do
  import Plug.Conn

  alias JustCi.Repo
  alias JustCi.Job
  alias JustCi.BuildTask
  alias JustCi.GithubStatus

  def start(build, sha, owner) do
    job = create_job(build.id, sha, owner)
    job_id = job.id

    # TODO: Figure out how to preload the build on create to prevent this stupid
    # second lookup
    job = Job
    |> Repo.get(job_id)
    |> Repo.preload(:build)

    BuildTask.run(job)
  end

  def create_job(build_id, sha, owner) do
    changeset = Job.changeset(%Job{}, %{
      build_id: build_id,
      sha: sha,
      owner: owner,
      status: "pending"
    })

    case Repo.insert changeset do
      {:ok, changeset} ->
        changeset
      {:error, changeset} ->
        raise RuntimeError, message: "There was a problem creating the job"
    end
  end
end
