defmodule JustCi.ThirdPartyKey do
  use JustCi.Web, :model

  schema "third_party_keys" do
    field :name, :string
    field :key, :string, size: 10000

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :key])
    |> validate_required([:name, :key])
  end
end
