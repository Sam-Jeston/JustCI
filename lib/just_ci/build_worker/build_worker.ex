defmodule JustCi.BuildWorker do
  import Plug.Conn
  alias JustCi.Job

  def start(build, sha, owner) do
    create_job(build.id, sha, owner)

    # This should also be managed by the Agent
    # 1. Create a new job entry
    # 2. Start the job (Elixir.Task)
    # 3. Push it to the Agent for reference
  end

  def implement_job do

  end

  def create_job(build_id, sha, owner) do
    changeset = Job.changeset(%Job{}, %{
      build_id: build_id,
      sha: sha,
      owner: owner,
      status: "pending",
      log: "Not yet created"
    })

    case JustCi.Job.create(changeset, JustCi.Repo) do
      {:ok, changeset} ->
        changeset
      {:error, changeset} ->
        raise RuntimeError, message: "There was a problem creating the job"
    end
  end
end
