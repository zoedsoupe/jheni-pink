defmodule SiteWeb.Plugs.FetchJheneSession do
  @moduledoc """
  Reads the optional :jhene_session token from the session cookie and assigns
  :jhene_authorized + :current_jhene on the conn for every request. LiveViews
  can read these via on_mount.
  """

  import Plug.Conn

  alias SiteWeb.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :jhene_session) do
      nil ->
        assign_not_authed(conn)

      token ->
        case Auth.verify_session_token(SiteWeb.Endpoint, token) do
          {:ok, email} ->
            conn
            |> assign(:jhene_authorized, true)
            |> assign(:current_jhene, email)

          _ ->
            conn
            |> delete_session(:jhene_session)
            |> assign_not_authed()
        end
    end
  end

  defp assign_not_authed(conn) do
    conn
    |> assign(:jhene_authorized, false)
    |> assign(:current_jhene, nil)
  end
end
