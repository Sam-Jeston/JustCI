defmodule JustCi.BuildTest do
  use JustCi.ModelCase

  alias JustCi.Build

  @valid_attrs %{repo: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Build.changeset(%Build{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Build.changeset(%Build{}, @invalid_attrs)
    refute changeset.valid?
  end
end
