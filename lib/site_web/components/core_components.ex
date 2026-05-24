defmodule SiteWeb.CoreComponents do
  @moduledoc """
  Minimal helpers used by templates. Gettext-backed error translation.
  Visual components live inline in each LiveView using the Y2K design system in app.css.
  """
  use Phoenix.Component
  use Gettext, backend: SiteWeb.Gettext

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(SiteWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(SiteWeb.Gettext, "errors", msg, opts)
    end
  end

  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
