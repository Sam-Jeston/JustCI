defmodule JustCi.GithubController do
  use JustCi.Web, :controller

  alias JustCi.Build
  alias JustCi.BuildWorker
  alias JustCi.GithubStatus

  def start_job(conn, params) do
    headers = conn.req_headers

    github_event_tuple = Enum.find(headers, fn(h) -> elem(h, 0) == "x-github-event" end)
    github_event = elem(github_event_tuple, 1)

    if valid_event?(github_event) && valid_action?(params["action"]) do
      { repo, test_sha, owner } = assign_repo_vals(github_event, params)
      branch = GithubStatus.branch_name(test_sha)

      build_query = from b in Build,
        where: b.repo == ^repo

      build = Repo.all(build_query)

      build_match = length build

      if build_match != 1 do
        conn
        |> put_status(500)
        |> json(%{message: "No matching build"})
      end

      GithubStatus.set_pending_status(repo, owner, test_sha)

      builder = Enum.at(build, 0)
      BuildWorker.start(builder, test_sha, owner, branch)
    end

    send_resp(conn, :no_content, "")
  end

  defp assign_repo_vals(github_event, github_body) do
    case is_pr?(github_event) do
      true -> {
        github_body["pull_request"]["base"]["repo"]["name"],
        github_body["pull_request"]["head"]["sha"],
        github_body["pull_request"]["base"]["repo"]["owner"]["login"]
      }
      false -> {
        github_body["repository"]["name"],
        github_body["after"],
        github_body["repository"]["owner"]["name"]
      }
    end
  end

  defp valid_event?(event_name) do
    target_events = ["pull_request", "push"]
    !!Enum.find(target_events, fn(e) -> String.equivalent?(event_name, e) end)
  end

  defp is_pr?(event_name) do
    !!String.equivalent?(event_name, "pull_request")
  end

  defp valid_action?(action) do
    !String.equivalent?(action, "closed")
  end
end
