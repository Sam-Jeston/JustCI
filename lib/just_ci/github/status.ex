defmodule JustCi.GithubStatus do
  def set_pending_status(repo, owner, sha) do
    client = client_instance()

    comment_body = %{
     "state": "pending",
     "target_url": "https://willLinkBackToActualCIBuild.com/build/status",
     "description": "About to start the build!",
     "context": "continuous-integration/JustCi"
    }

    Tentacat.Repositories.Statuses.create(owner, repo, sha, comment_body, client)
  end

  def set_passed_status(repo, owner, sha) do
    client = client_instance()

    comment_body = %{
     "state": "success",
     "target_url": "https://willLinkBackToActualCIBuild.com/build/status",
     "description": "The build passed!!",
     "context": "continuous-integration/JustCi"
    }

    Tentacat.Repositories.Statuses.create(owner, repo, sha, comment_body, client)
  end

  def set_failed_status(repo, owner, sha) do
    client = client_instance()

    comment_body = %{
     "state": "failure",
     "target_url": "https://willLinkBackToActualCIBuild.com/build/status",
     "description": "The build failed!",
     "context": "continuous-integration/JustCi"
    }

    Tentacat.Repositories.Statuses.create(owner, repo, sha, comment_body, client)
  end

  # TODO: Use Tentacat to return the branch name
  def branch_name(sha) do
    "fake-branch"
  end

  defp client_instance do
    token = System.get_env("GITHUB_TOKEN")
    Tentacat.Client.new(%{access_token: token})
  end
end
