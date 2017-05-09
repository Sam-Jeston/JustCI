defmodule JustCi.Dependency do
  use JustCi.Web, :model

  schema "dependencies" do
    field :command, :string
    field :priority, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:command, :priority])
    |> validate_required([:command, :priority])
  end
end
