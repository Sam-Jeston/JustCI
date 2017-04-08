defmodule JustCi.JobLog do
  use JustCi.Web, :model

  schema "job_logs" do
    field :entry, :string
    belongs_to :job, JustCi.Job

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:entry])
    |> validate_required([:entry])
    |> foreign_key_constraint(:job_id)
  end
end
