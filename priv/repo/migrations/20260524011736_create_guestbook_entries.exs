defmodule Site.Repo.Migrations.CreateGuestbookEntries do
  use Ecto.Migration

  def change do
    create table(:guestbook_entries) do
      add :nome, :string, null: false
      add :mensagem, :text, null: false
      add :sticker, :string, null: false, default: "<3"
      add :ip, :string

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create index(:guestbook_entries, [:inserted_at])
    create index(:guestbook_entries, [:ip])
  end
end
