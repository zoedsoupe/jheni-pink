defmodule Site.Guestbook do
  @moduledoc """
  Context for the /livro guestbook.

  Persists entries, subscribes to PubSub broadcasts, and enforces an
  in-memory per-IP rate limit so the same visitor can't spam the form.
  """

  import Ecto.Query

  alias Site.Repo
  alias Site.Guestbook.Entry

  @topic "guestbook:entries"
  @rate_limit_table :guestbook_rate_limit
  @rate_limit_window_ms 30_000

  def topic, do: @topic

  def subscribe do
    Phoenix.PubSub.subscribe(Site.PubSub, @topic)
  end

  def list_recent(limit \\ 50) do
    Entry
    |> order_by(desc: :inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Entry.changeset(entry, attrs)
  end

  def create_entry(attrs, ip) do
    ensure_table!()

    cond do
      rate_limited?(ip) ->
        {:error, :rate_limited}

      true ->
        attrs = Map.put(attrs, "ip", ip)

        with {:ok, entry} <-
               %Entry{} |> Entry.changeset(attrs) |> Repo.insert() do
          touch_rate(ip)
          Phoenix.PubSub.broadcast(Site.PubSub, @topic, {:new_entry, entry})
          {:ok, entry}
        end
    end
  end

  defp rate_limited?(nil), do: false

  defp rate_limited?(ip) do
    now = System.monotonic_time(:millisecond)

    case :ets.lookup(@rate_limit_table, ip) do
      [{^ip, last}] when now - last < @rate_limit_window_ms -> true
      _ -> false
    end
  end

  defp touch_rate(nil), do: :ok

  defp touch_rate(ip) do
    :ets.insert(@rate_limit_table, {ip, System.monotonic_time(:millisecond)})
    :ok
  end

  defp ensure_table! do
    case :ets.whereis(@rate_limit_table) do
      :undefined ->
        :ets.new(@rate_limit_table, [:named_table, :public, :set, read_concurrency: true])

      _ ->
        :ok
    end
  end
end
