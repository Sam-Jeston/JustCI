defmodule JustCi.HomeController do
  use JustCi.Web, :controller
  alias JustCi.Build
  alias JustCi.Job
  alias JustCi.BuildTask
  alias JustCi.BuildWorker

  def index(conn, _params) do
    # TODO: Improve this query to order_by the build with the most recent job
    # instead of the Elixir sort
    builds_with_jobs = Build
    |> join(:left, [b], jobs in assoc(b, :jobs))
    |> order_by([b, jobs], [desc: jobs.updated_at])
    |> limit([jobs], 10)
    |> preload([b, jobs], [jobs: jobs])
    |> Repo.all

    builds_with_jobs = Enum.sort(builds_with_jobs, fn b1, b2 ->
      build_comparitor_one = if (b1.jobs == []), do: false, else: Enum.at(b1.jobs, 0).updated_at
      build_comparitor_two = if (b2.jobs == []), do: false, else: Enum.at(b2.jobs, 0).updated_at
      build_comparitor_one >= build_comparitor_two
    end)

    build_views = Enum.map(builds_with_jobs, fn b ->
      status =
        case b.jobs do
          [] -> "uninitiated"
          _ -> Enum.at(b.jobs, 0).status
        end

      %{id: b.id, status: status, repo: b.repo}
    end)

    render conn, "index.html", build_views: build_views
  end

  def show(conn, %{"id" => id}) do
    build = Build
    |> where([b], b.id == ^id)
    |> join(:left, [b], jobs in assoc(b, :jobs))
    |> order_by([b, jobs], [desc: jobs.updated_at])
    |> limit([jobs], 1)
    |> preload([b, jobs], [jobs: jobs])
    |> Repo.one

    job = Enum.at(build.jobs, 0)

    logs =
      case job do
        nil -> nil
        _ -> String.split(find_log(job), "\n")
      end

    render conn, "show.html", build: build, job: job, logs: logs
  end

  def history(conn, %{"id" => id}) do
    build_with_jobs = Build
    |> where([b], b.id == ^id)
    |> join(:left, [b], jobs in assoc(b, :jobs))
    |> order_by([b, jobs], [desc: jobs.updated_at])
    |> limit([jobs], 10)
    |> preload([b, jobs], [jobs: jobs])
    |> Repo.one

    render conn, "history.html", build: build_with_jobs
  end

  # TODO: Will require an addition to Job to store branch
  def branches(conn, %{"id" => id}) do
    build_with_jobs = Build
    |> where([b], b.id == ^id)
    |> join(:left, [b], jobs in assoc(b, :jobs))
    |> order_by([b, jobs], [desc: jobs.updated_at])
    |> limit([jobs], 10)
    |> preload([b, jobs], [jobs: jobs])
    |> Repo.one

    render conn, "branches.html", build: build_with_jobs
  end

  def restart_job(conn, %{"job_id" => job_id}) do
    job = Job
    |> Repo.get(job_id)
    |> Repo.preload(:build)

    new_job = BuildWorker.start(job.build, job.sha, job.owner, job.branch)
    json conn, %{id: new_job.id, status: "pending", branch: new_job.branch}
  end

  def find_log(job) do
    case job.log do
      nil ->
        BuildTask.aggregate_log(job.id)
      _ -> job.log
    end
  end
end
