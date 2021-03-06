defmodule JustCi.BuildTaskTest do
  use JustCi.ConnCase

  alias JustCi.BuildWorker
  alias JustCi.JobLog
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

    job = BuildWorker.create_job build.id, "AEBC", "JohnSnow", "master"

    {:ok, job: job}
  end

  # This spec is going to attempt a git clone, so maybe we go in from the point of
  # execute instead
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

  test "aggregate log correctly reduces job logs to a single entry", %{job: job} do
    job_log_1_changeset = JobLog.changeset(%JobLog{}, %{
      entry: "hello one\n",
      job_id: job.id
    })

    job_log_2_changeset = JobLog.changeset(%JobLog{}, %{
      entry: "hello two\n",
      job_id: job.id
    })

    Repo.insert! job_log_1_changeset
    Repo.insert! job_log_2_changeset

    aggregate_log = BuildTask.aggregate_log(job.id)
    expected_result = "hello one\nhello two\n"

    assert expected_result == aggregate_log
  end
end
