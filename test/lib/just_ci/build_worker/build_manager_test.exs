defmodule JustCi.BuildManagerTest do
  use ExUnit.Case

  test "stores new job in the agent" do
    job = %{job_id: 1}

    {:ok, manager} = JustCi.BuildManager.start_link
    assert JustCi.BuildManager.get_jobs(manager) == []

    JustCi.BuildManager.push(manager, job)
    assert JustCi.BuildManager.get_jobs(manager) == [job]
  end

  test "remove correctly removes an active job from the agent" do
    first_job = %{job_id: 1}
    second_job = %{job_id: 2}

    {:ok, manager} = JustCi.BuildManager.start_link

    JustCi.BuildManager.push(manager, first_job)
    JustCi.BuildManager.push(manager, second_job)
    assert JustCi.BuildManager.get_jobs(manager) == [second_job, first_job]

    JustCi.BuildManager.remove(manager, second_job)
    assert JustCi.BuildManager.get_jobs(manager) == [first_job]
  end
end
