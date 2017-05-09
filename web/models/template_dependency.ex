defmodule JustCi.TemplateDependency do
  use JustCi.Web, :model

  schema "template_dependencies" do
    belongs_to :template, JustCi.Template
    belongs_to :dependency, JustCi.Dependency

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:template_id, :dependency_id])
    |> validate_required([:template_id, :dependency_id])
  end
end
