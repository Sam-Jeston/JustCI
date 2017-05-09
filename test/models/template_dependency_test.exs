defmodule JustCi.TemplateDependencyTest do
  use JustCi.ModelCase

  alias JustCi.TemplateDependency

  @valid_attrs %{template_id: 1, dependency_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TemplateDependency.changeset(%TemplateDependency{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TemplateDependency.changeset(%TemplateDependency{}, @invalid_attrs)
    refute changeset.valid?
  end
end
