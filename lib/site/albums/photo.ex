defmodule Site.Albums.Photo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "photos" do
    field :filename, :string
    field :caption, :string
    field :position, :integer, default: 0

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(photo, attrs) do
    photo
    |> cast(attrs, [:filename, :caption, :position])
    |> validate_required([:filename])
    |> validate_length(:filename, max: 255)
    |> validate_length(:caption, max: 200)
  end
end
