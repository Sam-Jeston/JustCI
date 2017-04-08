defmodule JustCi.Repo.Migrations.CreateThirdPartyKey do
  use Ecto.Migration

  def change do
    create table(:third_party_keys) do
      add :entity, :string
      add :key, :string, size: 10000

      timestamps()
    end

  end
end
