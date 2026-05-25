defmodule Site.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :filename, :string, null: false
      add :caption, :string
      add :position, :integer, null: false, default: 0

      timestamps(type: :utc_datetime_usec)
    end

    create index(:photos, [:position])
  end
end
