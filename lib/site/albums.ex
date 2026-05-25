defmodule Site.Albums do
  @moduledoc """
  jhene's photo album. Public-readable, jhene-only-writable.

  Files live on disk under `uploads_dir/photos/`. DB row keeps just the
  filename + caption + position. The HTTP path `/uploads/photos/<filename>`
  is served by a Plug.Static entry in the endpoint.

  Auth enforced at the boundary: mutating functions require an explicit
  `true` authed? flag.
  """

  import Ecto.Query

  alias Site.Repo
  alias Site.Albums.Photo

  @topic "photos"

  def topic, do: @topic
  def subscribe, do: Phoenix.PubSub.subscribe(Site.PubSub, @topic)

  def list_photos do
    Photo
    |> order_by(asc: :position, asc: :inserted_at)
    |> Repo.all()
  end

  def get(id), do: Repo.get(Photo, id)

  def change_photo(%Photo{} = photo, attrs \\ %{}), do: Photo.changeset(photo, attrs)

  def create_photo(attrs, true) do
    next = (Repo.aggregate(Photo, :max, :position) || 0) + 1
    attrs = Map.put_new(attrs, "position", next)

    with {:ok, photo} <- %Photo{} |> Photo.changeset(attrs) |> Repo.insert() do
      broadcast({:photo_created, photo})
      {:ok, photo}
    end
  end

  def create_photo(_, _), do: {:error, :unauthorized}

  def update_photo(%Photo{} = photo, attrs, true) do
    with {:ok, p} <- photo |> Photo.changeset(attrs) |> Repo.update() do
      broadcast({:photo_updated, p})
      {:ok, p}
    end
  end

  def update_photo(_, _, _), do: {:error, :unauthorized}

  def delete_photo(%Photo{} = photo, true) do
    with {:ok, p} <- Repo.delete(photo) do
      photo.filename |> file_path() |> File.rm()
      broadcast({:photo_deleted, p})
      {:ok, p}
    end
  end

  def delete_photo(_, _), do: {:error, :unauthorized}

  @doc "Swap position with the adjacent photo in the given direction."
  def move(%Photo{} = photo, direction, true) when direction in [:up, :down] do
    siblings = list_photos()
    idx = Enum.find_index(siblings, &(&1.id == photo.id))

    target_idx =
      case direction do
        :up -> idx - 1
        :down -> idx + 1
      end

    cond do
      is_nil(idx) ->
        {:error, :not_found}

      target_idx < 0 or target_idx >= length(siblings) ->
        {:ok, photo}

      true ->
        other = Enum.at(siblings, target_idx)

        Repo.transaction(fn ->
          Repo.update!(Photo.changeset(photo, %{position: other.position}))
          Repo.update!(Photo.changeset(other, %{position: photo.position}))
        end)

        broadcast({:photo_reordered, photo})
        {:ok, get(photo.id)}
    end
  end

  def move(_, _, _), do: {:error, :unauthorized}

  # storage

  @doc """
  Returns absolute directory where uploaded photo files live.

  Reads `:site, :uploads_dir` config. Accepts either a binary path (used
  in prod, e.g. `/data/uploads`) or a `{otp_app, relative_path}` tuple
  (used in dev to resolve via Application.app_dir/2).
  """
  def uploads_dir do
    case Application.get_env(:site, :uploads_dir, {:site, "priv/static/uploads"}) do
      {app, path} -> Application.app_dir(app, path)
      path when is_binary(path) -> path
    end
  end

  def photos_dir, do: Path.join(uploads_dir(), "photos")

  def ensure_photos_dir! do
    File.mkdir_p!(photos_dir())
  end

  def file_path(filename), do: Path.join(photos_dir(), filename)

  def url(%Photo{filename: f}), do: "/uploads/photos/" <> f

  defp broadcast(msg), do: Phoenix.PubSub.broadcast(Site.PubSub, @topic, msg)
end
