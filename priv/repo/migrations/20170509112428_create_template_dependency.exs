defmodule JustCi.Repo.Migrations.CreateTemplateDependency do
  use Ecto.Migration

  def change do
    create table(:template_dependencies) do
      add :template_id, references(:templates, on_delete: :nothing)
      add :dependency_id, references(:dependencies, on_delete: :nothing)

      timestamps()
    end
    create index(:template_dependencies, [:template_id])
    create index(:template_dependencies, [:dependency_id])

  end
end
