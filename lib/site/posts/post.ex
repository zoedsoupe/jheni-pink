defmodule Site.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @stickers ["<3", ":)", ":3", "^_^", "T_T", ":(", "(O)", "\\o/", "*", "~"]

  schema "posts" do
    field :content, :string
    field :sticker, :string, default: "<3"

    timestamps(type: :utc_datetime_usec)
  end

  def stickers, do: @stickers

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content, :sticker])
    |> validate_required([:content, :sticker])
    |> validate_length(:content, min: 1, max: 500)
    |> validate_inclusion(:sticker, @stickers)
  end
end
