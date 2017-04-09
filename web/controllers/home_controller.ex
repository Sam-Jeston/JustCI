defmodule JustCi.HomeController do
  use JustCi.Web, :controller
  alias JustCi.Build

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
end
