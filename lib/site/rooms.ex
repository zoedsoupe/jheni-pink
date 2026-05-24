defmodule Site.Rooms do
  @moduledoc """
  Editable room content store.

  Each room has named "blocks" of text. Rooms read content via `value/3` which
  returns the DB override if any, otherwise the caller-supplied default. jhene
  edits a block -> upsert. Reset -> delete row -> fall back to default.

  Three parsers are provided so callers can render the same raw string as
  prose (text), an unordered list (lines), or key/value pairs (pairs).

  Mutating ops require an explicit authed? flag at the boundary -- defense
  in depth so a hypothetical hijacked LV event still cannot write.
  """

  alias Site.Repo
  alias Site.Rooms.Block

  @topic "rooms"

  def topic, do: @topic
  def subscribe, do: Phoenix.PubSub.subscribe(Site.PubSub, @topic)

  def get(room, key) do
    Repo.get_by(Block, room: room, key: key)
  end

  def value(room, key, default) do
    case get(room, key) do
      nil -> default
      %Block{value: v} -> v
    end
  end

  def upsert(room, key, value, true) do
    attrs = %{room: room, key: key, value: value}

    result =
      case get(room, key) do
        nil ->
          %Block{} |> Block.changeset(attrs) |> Repo.insert()

        block ->
          block |> Block.changeset(attrs) |> Repo.update()
      end

    with {:ok, block} <- result do
      broadcast({:room_block_updated, %{room: room, key: key, block: block}})
      {:ok, block}
    end
  end

  def upsert(_room, _key, _value, _), do: {:error, :unauthorized}

  def delete(room, key, true) do
    case get(room, key) do
      nil ->
        :ok

      block ->
        with {:ok, _} <- Repo.delete(block) do
          broadcast({:room_block_deleted, %{room: room, key: key}})
          :ok
        end
    end
  end

  def delete(_room, _key, _), do: {:error, :unauthorized}

  # parsers

  @doc "Split a block's raw string into trimmed non-empty lines."
  def lines(value) when is_binary(value) do
    value
    |> String.split("\n", trim: false)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  @doc ~S"""
  Parse a block as `key | value` pairs (one per line). Returns list of {k, v}
  preserving order. Lines without a pipe are kept as {nil, line}.
  """
  def pairs(value) when is_binary(value) do
    value
    |> lines()
    |> Enum.map(fn line ->
      case String.split(line, "|", parts: 2) do
        [k, v] -> {String.trim(k), String.trim(v)}
        [v] -> {nil, String.trim(v)}
      end
    end)
  end

  @doc "Split a block into prose paragraphs (blank-line separated)."
  def paragraphs(value) when is_binary(value) do
    value
    |> String.split(~r/\n\s*\n+/, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  @doc ~S"""
  Parse a block of structured records. Records are separated by blank lines;
  inside each record, lines follow `key: value` (binary keys). Returns a list
  of maps with binary keys preserving record order.
  """
  def records(value) when is_binary(value) do
    value
    |> String.split(~r/\n\s*\n+/, trim: true)
    |> Enum.map(fn record ->
      record
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn line, acc ->
        case String.split(line, ":", parts: 2) do
          [k, v] -> Map.put(acc, String.trim(k), String.trim(v))
          _ -> acc
        end
      end)
    end)
    |> Enum.reject(&(map_size(&1) == 0))
  end

  defp broadcast(msg), do: Phoenix.PubSub.broadcast(Site.PubSub, @topic, msg)
end
