defmodule SiteWeb.AuthController do
  use SiteWeb, :controller

  alias SiteWeb.Auth

  # GET /cartas/entrar
  def new(conn, _params) do
    render(conn, :new, sent: false)
  end

  # POST /cartas/entrar
  def create(conn, %{"email" => email}) do
    email = email |> to_string() |> String.trim()

    if Auth.whitelisted?(email) do
      token = Auth.login_token(SiteWeb.Endpoint, email)
      url = url(~p"/cartas/entrar/#{token}")
      _ = Auth.deliver_login_email(email, url)
    end

    # Always render the same response to avoid leaking which email is whitelisted.
    render(conn, :new, sent: true)
  end

  # GET /cartas/entrar/:token
  def verify(conn, %{"token" => token}) do
    case Auth.verify_login_token(SiteWeb.Endpoint, token) do
      {:ok, email} ->
        session_token = Auth.session_token(SiteWeb.Endpoint, email)

        conn
        |> configure_session(renew: true)
        |> put_session(:jhene_session, session_token)
        |> put_flash(:info, "bem-vinda, jhene <3")
        |> redirect(to: ~p"/mapa")

      _ ->
        conn
        |> put_flash(:error, "link inválido ou expirado. pede outro :)")
        |> redirect(to: ~p"/cartas/entrar")
    end
  end

  # DELETE /cartas/sair
  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "ate logo")
    |> redirect(to: ~p"/cartas")
  end
end
