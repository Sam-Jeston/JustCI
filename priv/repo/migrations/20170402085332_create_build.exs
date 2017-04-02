defmodule JustCi.Repo.Migrations.CreateBuild do
  use Ecto.Migration

  def change do
    create table(:builds) do
      add :repo, :string
      add :template_id, references(:templates, on_delete: :nothing)

      timestamps()
    end
    create index(:builds, [:template_id])

  end
end
