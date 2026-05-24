defmodule SiteWeb.SplashLive do
  use SiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "jheni.pink ♡")}
  end

  def render(assigns) do
    ~H"""
    <main class="bg-splash min-h-screen flex items-center justify-center p-6">
      <div class="text-center w-full max-w-lg">
        <h1 class="wordart text-6xl sm:text-7xl mb-6">jheni.pink</h1>
        <p class="font-pixel text-cream text-lg mb-10 tracking-wider">
          ♡ site oficial da jhujubinha ♡
        </p>

        <.link navigate={~p"/mapa"} class="btn-y2k btn-pulse">
          ENTER ♡
        </.link>

        <div class="font-pixel text-bubblegum text-sm mt-10 leading-relaxed">
          best viewed in any device ♀♀<br />
          made with love by <a href="https://zeetech.io">zoey</a> ♡
        </div>
      </div>
    </main>
    """
  end
end
