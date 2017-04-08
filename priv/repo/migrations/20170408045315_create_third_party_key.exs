defmodule JustCi.Repo.Migrations.CreateThirdPartyKey do
  use Ecto.Migration

  def change do
    create table(:third_party_keys) do
      add :entity, :string
      add :key, :string

      timestamps()
    end

  end
end
