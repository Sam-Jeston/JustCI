defmodule JustCi.GithubStatus do
  def set_pending_status(repo, owner, sha) do
    token = System.get_env("GITHUB_TOKEN")
    client = Tentacat.Client.new(%{access_token: token})

    comment_body = %{
     "state": "pending",
     "target_url": "https://willLinkBackToActualCIBuild.com/build/status",
     "description": "About to start the build!",
     "context": "continuous-integration/JustCi"
    }

    Tentacat.Repositories.Statuses.create(owner, repo, sha, comment_body, client)
  end

  def set_passed_status(repo, owner, sha) do
    token = System.get_env("GITHUB_TOKEN")
    client = Tentacat.Client.new(%{access_token: token})

    comment_body = %{
     "state": "success",
     "target_url": "https://willLinkBackToActualCIBuild.com/build/status",
     "description": "The build passed!!",
     "context": "continuous-integration/JustCi"
    }

    Tentacat.Repositories.Statuses.create(owner, repo, sha, comment_body, client)
  end

  def set_failed_status(repo, owner, sha) do
    token = System.get_env("GITHUB_TOKEN")
    client = Tentacat.Client.new(%{access_token: token})

    comment_body = %{
     "state": "failure",
     "target_url": "https://willLinkBackToActualCIBuild.com/build/status",
     "description": "The build failed!",
     "context": "continuous-integration/JustCi"
    }

    Tentacat.Repositories.Statuses.create(owner, repo, sha, comment_body, client)
  end
end
