defmodule JustCi.JobTest do
  use JustCi.ModelCase

  alias JustCi.Job

  @valid_attrs %{log: "some content", owner: "some content", sha: "some content", status: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Job.changeset(%Job{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Job.changeset(%Job{}, @invalid_attrs)
    refute changeset.valid?
  end
end
