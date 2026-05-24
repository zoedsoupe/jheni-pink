defmodule Site.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :content, :text, null: false
      add :sticker, :string, null: false, default: "<3"

      timestamps(type: :utc_datetime_usec)
    end

    create index(:posts, [:inserted_at])
  end
end
