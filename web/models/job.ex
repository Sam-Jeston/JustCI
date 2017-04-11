defmodule JustCi.Job do
  use JustCi.Web, :model

  schema "jobs" do
    field :status, :string
    field :branch, :string
    field :log, :string, size: 1000000
    field :sha, :string
    field :owner, :string
    belongs_to :build, JustCi.Build

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :log, :sha, :owner, :build_id, :branch])
    |> validate_required([:status, :sha, :owner, :build_id, :branch])
    |> foreign_key_constraint(:build_id)
  end
end
