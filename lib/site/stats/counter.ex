defmodule Site.Stats.Counter do
  use Ecto.Schema

  @primary_key {:name, :string, autogenerate: false}
  schema "site_counters" do
    field :value, :integer, default: 0
  end
end
