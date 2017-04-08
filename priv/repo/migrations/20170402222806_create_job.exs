defmodule JustCi.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :status, :string
      add :log, :string, size: 1000000
      add :sha, :string
      add :owner, :string
      add :build_id, references(:builds, on_delete: :nothing)

      timestamps()
    end
    create index(:jobs, [:build_id])

  end
end
