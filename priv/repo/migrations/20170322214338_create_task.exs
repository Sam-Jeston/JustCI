defmodule JustCi.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :string
      add :command, :string
      add :order, :integer, default: 1
      add :template_id, references(:templates, on_delete: :nothing)

      timestamps()
    end
    create index(:tasks, [:template_id])

  end
end
