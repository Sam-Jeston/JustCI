defmodule JustCi.BuildWorker do
  import Plug.Conn

  alias JustCi.Repo
  alias JustCi.Job
  alias JustCi.BuildTask

  def start(build, sha, owner) do
    IO.inspect build
    job = create_job(build.id, sha, owner)
    BuildTask.run(job)
  end

  def create_job(build_id, sha, owner) do
    changeset = Job.changeset(%Job{}, %{
      build_id: build_id,
      sha: sha,
      owner: owner,
      status: "pending",
      log: "Not yet created"
    })

    case Repo.insert changeset do
      {:ok, changeset} ->
        changeset
      {:error, changeset} ->
        raise RuntimeError, message: "There was a problem creating the job"
    end
  end
end
