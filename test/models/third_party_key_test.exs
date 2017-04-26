defmodule JustCi.ThirdPartyKeyTest do
  use JustCi.ModelCase

  alias JustCi.ThirdPartyKey

  @valid_attrs %{name: "some content", key: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ThirdPartyKey.changeset(%ThirdPartyKey{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ThirdPartyKey.changeset(%ThirdPartyKey{}, @invalid_attrs)
    refute changeset.valid?
  end
end
