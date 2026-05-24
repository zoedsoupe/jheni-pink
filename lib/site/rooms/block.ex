defmodule Site.Rooms.Block do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_blocks" do
    field :room, :string
    field :key, :string
    field :value, :string

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(block, attrs) do
    block
    |> cast(attrs, [:room, :key, :value])
    |> validate_required([:room, :key, :value])
    |> validate_length(:value, max: 5000)
    |> unique_constraint([:room, :key])
  end
end
