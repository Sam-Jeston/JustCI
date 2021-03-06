defmodule JustCi.UserTest do
  use JustCi.ModelCase

  alias JustCi.User

  @valid_attrs %{
    password: "some content",
    email: "x@y"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
