defmodule SiteWeb.Auth do
  @moduledoc """
  Magic-link auth for /cartas. Whitelisted to a single email.

  - Login token: short-lived, signed with Phoenix.Token, embedded in a URL we
    email to the user. They click it, we exchange it for a session token.
  - Session token: long-lived, stored in the session cookie.

  No DB tables required; everything is signed.
  """

  import Swoosh.Email

  alias Phoenix.Token
  alias Site.Mailer

  @salt_login "jeni-cartas-login"
  @salt_session "jeni-cartas-session"

  def jhene_email do
    Application.fetch_env!(:site, __MODULE__) |> Keyword.fetch!(:jhene_email)
  end

  def from_email do
    Application.fetch_env!(:site, __MODULE__) |> Keyword.fetch!(:from_email)
  end

  def login_max_age do
    Application.fetch_env!(:site, __MODULE__) |> Keyword.fetch!(:login_max_age)
  end

  def session_max_age do
    Application.fetch_env!(:site, __MODULE__) |> Keyword.fetch!(:session_max_age)
  end

  def whitelisted?(email) when is_binary(email) do
    String.downcase(String.trim(email)) == String.downcase(jhene_email())
  end

  def whitelisted?(_), do: false

  def login_token(endpoint, email) do
    Token.sign(endpoint, @salt_login, %{email: String.downcase(email)})
  end

  def verify_login_token(endpoint, token) do
    case Token.verify(endpoint, @salt_login, token, max_age: login_max_age()) do
      {:ok, %{email: email}} -> if whitelisted?(email), do: {:ok, email}, else: {:error, :forbidden}
      other -> other
    end
  end

  def session_token(endpoint, email) do
    Token.sign(endpoint, @salt_session, %{email: String.downcase(email)})
  end

  def verify_session_token(endpoint, token) do
    case Token.verify(endpoint, @salt_session, token, max_age: session_max_age()) do
      {:ok, %{email: email}} -> if whitelisted?(email), do: {:ok, email}, else: {:error, :forbidden}
      other -> other
    end
  end

  def deliver_login_email(email, login_url) do
    new()
    |> to({"jhene", email})
    |> from(from_email())
    |> subject("[ jeni.pink ] seu link pra entrar no modo edição")
    |> text_body("""
    oi jhene!

    clica nesse link pra entrar no modo edição do site (vale por 15 min):

    #{login_url}

    com esse login você consegue editar as rooms, postar no diário, e ler
    as cartas. se não foi você, ignora.

    beijos,
    zoeyrinha
    """)
    |> Mailer.deliver()
  end
end
