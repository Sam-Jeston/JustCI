defmodule JustCi.Repo.Migrations.CreateJobLog do
  use Ecto.Migration

  def change do
    create table(:job_logs) do
      add :entry, :string, size: 100000
      add :job_id, references(:jobs, on_delete: :nothing)

      timestamps()
    end
    create index(:job_logs, [:job_id])

  end
end
