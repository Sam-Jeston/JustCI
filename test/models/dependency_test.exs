defmodule JustCi.DependencyTest do
  use JustCi.ModelCase

  alias JustCi.Dependency

  @valid_attrs %{command: "some content", priority: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Dependency.changeset(%Dependency{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Dependency.changeset(%Dependency{}, @invalid_attrs)
    refute changeset.valid?
  end
end
