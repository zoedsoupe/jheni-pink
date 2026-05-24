defmodule SiteWeb.CartasLive do
  use SiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "cartas")}
  end

  def render(assigns) do
    ~H"""
    <main class="bg-construction min-h-screen flex items-center justify-center p-6">
      <div class="card-y2k max-w-md text-center shadow-deep border-5">
        <span class="gif-bounce text-5xl block mb-4 font-pixel">[ @ ]</span>
        <h1 class="wordart text-3xl mb-2">cartas</h1>
        <p class="font-pixel text-vinho-soft text-lg mb-4">pagina em construcao</p>
        <p class="tape mb-4">[ work in progress ]</p>
        <.link navigate={~p"/mapa"} class="btn-y2k">&lt;- mapa</.link>
      </div>
    </main>
    """
  end
end
