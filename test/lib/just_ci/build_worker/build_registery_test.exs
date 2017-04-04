defmodule JustCi.BuildRegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = JustCi.BuildRegistry.start_link
    {:ok, registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert JustCi.BuildRegistry.lookup(registry, "manager") == :error

    JustCi.BuildRegistry.create(registry, "manager")
    assert {:ok, manager} = JustCi.BuildRegistry.lookup(registry, "manager")

    JustCi.BuildManager.push(manager, %{job_id: 1})
    assert JustCi.BuildManager.get_jobs(manager) == [%{job_id: 1}]
  end
end
