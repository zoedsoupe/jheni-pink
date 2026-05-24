defmodule Site.Guestbook.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  @stickers ["<3", ":)", ":(", "(O)", "\\o/"]

  schema "guestbook_entries" do
    field :nome, :string
    field :mensagem, :string
    field :sticker, :string, default: "<3"
    field :ip, :string

    timestamps(type: :utc_datetime_usec, updated_at: false)
  end

  def stickers, do: @stickers

  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:nome, :mensagem, :sticker, :ip])
    |> validate_required([:nome, :mensagem, :sticker])
    |> validate_length(:nome, min: 1, max: 40)
    |> validate_length(:mensagem, min: 2, max: 500)
    |> validate_inclusion(:sticker, @stickers)
  end
end
