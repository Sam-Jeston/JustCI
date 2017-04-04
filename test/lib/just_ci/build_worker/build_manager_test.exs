defmodule JustCi.BuildManagerTest do
  use ExUnit.Case

  test "stores new job in the agent" do
    job = %{job_id: 1}

    {:ok, bucket} = JustCi.BuildManager.start_link
    assert JustCi.BuildManager.get_jobs == []

    JustCi.BuildManager.push(job)
    assert JustCi.BuildManager.get_jobs == [job]
  end

  test "remove correctly removes an active job from the agent" do
    first_job = %{job_id: 1}
    second_job = %{job_id: 2}

    {:ok, bucket} = JustCi.BuildManager.start_link

    JustCi.BuildManager.push(first_job)
    JustCi.BuildManager.push(second_job)
    assert JustCi.BuildManager.get_jobs == [second_job, first_job]

    JustCi.BuildManager.remove(second_job)
    assert JustCi.BuildManager.get_jobs == [first_job]
  end
end
