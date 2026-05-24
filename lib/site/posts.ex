defmodule Site.Posts do
  @moduledoc """
  jhene's micro-blog feed. Public-readable, jhene-only-writable.

  Auth is enforced at the boundary: every mutating function requires the
  caller to pass `true` for the `authed?` flag. The LV calls these with
  the value of socket.assigns.jhene_authorized so that an attacker who
  manages to dispatch a phx-click event still cannot mutate.
  """

  import Ecto.Query

  alias Site.Repo
  alias Site.Posts.Post

  @topic "posts"

  def topic, do: @topic
  def subscribe, do: Phoenix.PubSub.subscribe(Site.PubSub, @topic)

  def list_recent(limit \\ 100) do
    Post
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  def get(id), do: Repo.get(Post, id)

  def change_post(%Post{} = post, attrs \\ %{}), do: Post.changeset(post, attrs)

  def create_post(attrs, true) do
    with {:ok, post} <- %Post{} |> Post.changeset(attrs) |> Repo.insert() do
      broadcast({:post_created, post})
      {:ok, post}
    end
  end

  def create_post(_attrs, _), do: {:error, :unauthorized}

  def update_post(%Post{} = post, attrs, true) do
    with {:ok, p} <- post |> Post.changeset(attrs) |> Repo.update() do
      broadcast({:post_updated, p})
      {:ok, p}
    end
  end

  def update_post(_post, _attrs, _), do: {:error, :unauthorized}

  def delete_post(%Post{} = post, true) do
    with {:ok, p} <- Repo.delete(post) do
      broadcast({:post_deleted, p})
      {:ok, p}
    end
  end

  def delete_post(_, _), do: {:error, :unauthorized}

  defp broadcast(msg), do: Phoenix.PubSub.broadcast(Site.PubSub, @topic, msg)
end
