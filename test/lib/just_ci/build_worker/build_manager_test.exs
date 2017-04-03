defmodule JustCi.BuildManagerTest do
  use ExUnit.Case

  test "stores new job in the agent" do
    job = %{job_id: 1}

    {:ok, bucket} = JustCi.BuildManager.start_link
    assert JustCi.BuildManager.get_jobs == []

    JustCi.BuildManager.push(job)
    assert JustCi.BuildManager.get_jobs == [job]
  end
end
