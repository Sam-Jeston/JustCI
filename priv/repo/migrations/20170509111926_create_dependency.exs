defmodule JustCi.Repo.Migrations.CreateDependency do
  use Ecto.Migration

  def change do
    create table(:dependencies) do
      add :command, :string
      add :priority, :integer

      timestamps()
    end

  end
end
