defmodule SiteWeb.Layouts do
  @moduledoc """
  Holds layouts. Only the root layout is used; each LiveView renders its full
  page contents directly inside the body.
  """
  use SiteWeb, :html

  embed_templates "layouts/*"
end
