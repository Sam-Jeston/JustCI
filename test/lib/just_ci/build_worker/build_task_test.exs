defmodule JustCi.BuildTaskTest do
  use JustCi.ConnCase

  alias JustCi.BuildWorker
  alias JustCi.Repo
  alias JustCi.Build
  alias JustCi.Template
  alias JustCi.Task
  alias JustCi.BuildTask

  setup do
    template_changeset = Template.changeset(%Template{}, %{name: "some content"})
    template = Repo.insert! template_changeset

    task_one_changeset = Task.changeset %Task{}, %{
      command: "echo \"Hello World!\"",
      description: "some content",
      template_id: template.id,
      order: 2
    }

    task_two_changeset = Task.changeset %Task{}, %{
      command: "echo \"Hello World Again!\"",
      description: "some content",
      template_id: template.id,
      order: 1
    }

    task_three_changeset = Task.changeset %Task{}, %{
      command: "echo \"Hello World Again!\"",
      description: "some content",
      template_id: template.id,
      order: 3
    }

    Repo.insert! task_one_changeset
    Repo.insert! task_two_changeset
    Repo.insert! task_three_changeset

    build_changeset = Build.changeset(%Build{}, %{repo: "some content", template_id: template.id})
    build = Repo.insert! build_changeset

    job = BuildWorker.create_job build.id, "AEBC", "JohnSnow"

    {:ok, job: job}
  end

  test "run completes the job and updates its status to completed", %{job: job} do
  end

  test "run completes the job and updates its status to failed", %{job: job} do
  end

  test "find_template_tasks returns all tasks in order", %{job: job} do
    tasks = BuildTask.find_template_tasks(job)
    assert Enum.at(tasks, 0).order == 1
    assert Enum.at(tasks, 1).order == 2
    assert Enum.at(tasks, 2).order == 3
  end

  test "execute runs the command and appends it to the correct job log" do
    BuildTask.execute("echo \"Hello world!\"")
  end
end
