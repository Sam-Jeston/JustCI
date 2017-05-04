defmodule JustCi.Template do
  use JustCi.Web, :model

  schema "templates" do
    field :name, :string
    has_many :tasks, JustCi.Task
    belongs_to :third_party_key, JustCi.ThirdPartyKey

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    IO.inspect struct
    struct
    |> cast(params, [:name, :third_party_key_id])
    |> validate_required([:name])
    |> foreign_key_constraint(:third_party_key_id)
  end
end
