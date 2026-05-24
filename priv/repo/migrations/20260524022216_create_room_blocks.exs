defmodule Site.Repo.Migrations.CreateRoomBlocks do
  use Ecto.Migration

  def change do
    create table(:room_blocks) do
      add :room, :string, null: false
      add :key, :string, null: false
      add :value, :text, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:room_blocks, [:room, :key])
  end
end
