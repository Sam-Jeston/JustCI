defmodule JustCi.Repo.Migrations.CreateTemplate do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :name, :string
      add :third_party_key_id, references(:third_party_keys, on_delete: :nothing)

      timestamps()
    end
    create index(:templates, [:third_party_key_id])

  end
end
