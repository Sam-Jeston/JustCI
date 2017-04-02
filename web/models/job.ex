defmodule JustCi.Job do
  use JustCi.Web, :model

  schema "jobs" do
    field :status, :string
    field :log, :string
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
    |> cast(params, [:status, :log, :sha, :owner, :build_id])
    |> validate_required([:status, :log, :sha, :owner, :build_id])
  end
end
