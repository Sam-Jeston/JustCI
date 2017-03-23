defmodule JustCi.Task do
  use JustCi.Web, :model

  schema "tasks" do
    field :description, :string
    field :command, :string
    belongs_to :template, JustCi.Template

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :command, :template_id])
    |> assoc_constraint(:template)
    |> validate_required([:description, :command])
  end
end
