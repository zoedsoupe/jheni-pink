defmodule Site.Repo.Migrations.CreateSiteCounters do
  use Ecto.Migration

  def change do
    create table(:site_counters, primary_key: false) do
      add :name, :string, primary_key: true
      add :value, :integer, null: false, default: 0
    end

    execute(
      "INSERT INTO site_counters (name, value) VALUES ('visits', 0)",
      "DELETE FROM site_counters WHERE name = 'visits'"
    )
  end
end
