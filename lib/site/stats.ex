defmodule Site.Stats do
  @moduledoc """
  Site-wide counters. Currently only tracks splash visits.
  """

  import Ecto.Query

  alias Site.Repo
  alias Site.Stats.Counter

  @visits "visits"

  def bump_visits do
    from(c in Counter, where: c.name == ^@visits)
    |> Repo.update_all(inc: [value: 1])

    :ok
  end

  def get_visits do
    Repo.one(from c in Counter, where: c.name == ^@visits, select: c.value) || 0
  end

  def format_visits(n, width \\ 5) do
    n |> Integer.to_string() |> String.pad_leading(width, "0")
  end
end
