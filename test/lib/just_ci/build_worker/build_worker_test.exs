defmodule JustCi.BuildWorkerTest do
  # ConnCase gives us Ecto happiness
  # TODO: Why is this?
  use JustCi.ConnCase

  alias JustCi.BuildWorker
  alias JustCi.Repo
  alias JustCi.Build
  alias JustCi.Template
  alias JustCi.Job

  setup do
    template_changeset = Template.changeset(%Template{}, %{name: "some content"})
    template = Repo.insert! template_changeset

    build_changeset = Build.changeset(%Build{}, %{repo: "some content", template_id: template.id})
    build = Repo.insert! build_changeset

    {:ok, build: build}
  end

  test "create job succeeds when the changeset is valid", %{build: build} do
    assert BuildWorker.create_job(build.id, "githubSha", "RonWeasley")
  end

  test "create job fails when the changeset is invalid" do
    assert_raise RuntimeError, "There was a problem creating the job", fn ->
      BuildWorker.create_job(99999999, "githubSha", "RonWeasley")
    end
  end
end
