defmodule JustCi.Task do
  use JustCi.Web, :model

  schema "tasks" do
    field :description, :string
    field :command, :string
    field :order, :integer
    belongs_to :template, JustCi.Template

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :command, :template_id, :order])
    |> assoc_constraint(:template)
    |> validate_required([:description, :command])
  end
end
