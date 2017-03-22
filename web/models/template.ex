defmodule JustCi.Template do
  use JustCi.Web, :model

  schema "templates" do
    field :name, :string
    has_many :tasks, JustCi.Task

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
