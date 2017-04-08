defmodule JustCi.JobLogTest do
  use JustCi.ModelCase

  alias JustCi.JobLog

  @valid_attrs %{entry: "some content", job_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = JobLog.changeset(%JobLog{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = JobLog.changeset(%JobLog{}, @invalid_attrs)
    refute changeset.valid?
  end
end
