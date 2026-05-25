defmodule SiteWeb.Router do
  use SiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SiteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SiteWeb.Plugs.FetchJheneSession
  end

  scope "/", SiteWeb do
    pipe_through :browser

    get "/cartas/entrar", AuthController, :new
    post "/cartas/entrar", AuthController, :create
    get "/cartas/entrar/:token", AuthController, :verify
    delete "/cartas/sair", AuthController, :delete

    live_session :default, on_mount: SiteWeb.LiveAuth do
      live "/", SplashLive, :index
      live "/mapa", MapaLive, :index
      live "/quarto", QuartoLive, :index
      live "/cheer", CheerLive, :index
      live "/psico", PsicoLive, :index
      live "/menu", MenuLive, :index
      live "/cartas", CartasLive, :index
      live "/lesbica", LesbicaLive, :index
      live "/livro", LivroLive, :index
      live "/links", LinksLive, :index
      live "/diario", DiarioLive, :index
      live "/album", AlbumLive, :index
    end
  end

  if Application.compile_env(:site, :dev_routes) do
    scope "/dev" do
      pipe_through :browser
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
