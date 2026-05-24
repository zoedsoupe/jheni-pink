defmodule SiteWeb.LiveAuth do
  @moduledoc """
  on_mount hook: reads the jhene_session token from the LV session and
  assigns :jhene_authorized + :current_jhene on the socket.
  """

  import Phoenix.Component, only: [assign: 3]

  alias SiteWeb.Auth

  def on_mount(:default, _params, session, socket) do
    {authed?, email} =
      case session["jhene_session"] do
        nil ->
          {false, nil}

        token ->
          case Auth.verify_session_token(SiteWeb.Endpoint, token) do
            {:ok, email} -> {true, email}
            _ -> {false, nil}
          end
      end

    socket =
      socket
      |> assign(:jhene_authorized, authed?)
      |> assign(:current_jhene, email)

    {:cont, socket}
  end
end
