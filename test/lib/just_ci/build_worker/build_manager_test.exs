defmodule JustCi.BuildManagerTest do
  use ExUnit.Case

  test "stores values by key" do
    {:ok, bucket} = JustCi.BuildManager.start_link
    assert JustCi.BuildManager.get(bucket, "milk") == nil

    JustCi.BuildManager.put(bucket, "milk", 3)
    assert JustCi.BuildManager.get(bucket, "milk") == 3
  end
end
