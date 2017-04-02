defmodule JustCi.GithubController do
  use JustCi.Web, :controller

  def start_job(conn, params) do
    headers = conn.req_headers

    github_event_tuple = Enum.find(headers, fn(h) -> elem(h, 0) == "x-github-event" end)
    github_event = elem(github_event_tuple, 1)

    if valid_event?(github_event) && valid_action?(params["action"]) do
      # TODO: Before we set pending status, lets check that we have a job that matches
      # the name of the repo

      if is_pr?(github_event) do
        repo = params["pull_request"]["base"]["repo"]["name"]
        test_sha = params["pull_request"]["head"]["sha"]
        owner = params["pull_request"]["base"]["repo"]["owner"]["login"]
      else
        repo = params["repository"]["name"]
        test_sha = params["after"]
        owner = params["repository"]["owner"]["name"]
      end

      set_pending_status(repo, owner, test_sha)

      # TODO: When we start the job, store the repo, test_sha and owner in the db
      # for easy reference when we go to set it to failed or passed
    end

    send_resp(conn, :no_content, "")
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
  defp set_pending_status(repo, owner, sha) do
    password = System.get_env("GITHUB_PASSWORD")
    IO.inspect password

    IO.inspect repo
    IO.inspect sha
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
