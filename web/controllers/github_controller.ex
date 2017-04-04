defmodule JustCi.GithubController do
  use JustCi.Web, :controller

  alias JustCi.Build
  alias JustCi.BuilWorker

  def start_job(conn, params) do
    headers = conn.req_headers

    github_event_tuple = Enum.find(headers, fn(h) -> elem(h, 0) == "x-github-event" end)
    github_event = elem(github_event_tuple, 1)

    if valid_event?(github_event) && valid_action?(params["action"]) do
      { repo, test_sha, owner } = assign_repo_vals(github_event, params)

      build_query = from b in Build,
        where: b.repo == ^repo

      build = Repo.all(build_query)

      build_match = length build

      if build_match != 1 do
        conn
        |> put_status(500)
        |> json(%{message: "No matching build"})
      end

      set_pending_status(repo, owner, test_sha)

      builder = Enum.at(build, 0)
      BuilWorker.start(build, test_sha, owner)
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

  # TODO: It will be better to use an access token here
  # TODO: Refactor to pass in the Tentacat Dep for improved testing
  defp set_pending_status(repo, owner, sha) do
    password = System.get_env("GITHUB_PASSWORD")
    client = Tentacat.Client.new(%{user: "Sam-Jeston", password: password})

    comment_body = %{
     "state": "pending",
     "target_url": "https://willLinkBackToActualCIBuild.com/build/status",
     "description": "About to start the build!",
     "context": "continuous-integration/JustCi"
    }

    Tentacat.Repositories.Statuses.create(owner, repo, sha, comment_body, client)
  end
end
