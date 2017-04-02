defmodule JustCi.Build do
  use JustCi.Web, :model

  schema "builds" do
    field :repo, :string
    belongs_to :template, JustCi.Template

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:repo, :template_id])
    |> validate_required([:repo, :template_id])
  end
end
