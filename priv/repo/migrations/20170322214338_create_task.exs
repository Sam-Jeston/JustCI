defmodule JustCi.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :string
      add :command, :string
      add :template_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:tasks, [:template_id])

  end
end
