defmodule SiteWeb.Presence do
  @moduledoc """
  Tracks which visitors are currently looking at the guestbook page.
  """

  use Phoenix.Presence,
    otp_app: :site,
    pubsub_server: Site.PubSub

  @topic "guestbook:presence"

  def topic, do: @topic

  def track_visitor(pid, visitor_id, meta \\ %{}) do
    track(pid, @topic, visitor_id, Map.put_new(meta, :joined_at, System.system_time(:second)))
  end

  def visitor_count do
    @topic |> list() |> map_size()
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Site.PubSub, @topic)
  end
end
