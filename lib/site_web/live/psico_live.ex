defmodule SiteWeb.PsicoLive do
  use SiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "psico ♡")}
  end

  def render(assigns) do
    ~H"""
    <main class="bg-construction min-h-screen flex items-center justify-center p-6">
      <div class="card-y2k max-w-md text-center shadow-deep border-5">
        <span class="gif-bounce text-6xl block mb-4">📚</span>
        <h1 class="wordart text-3xl mb-2">psicologia</h1>
        <p class="font-pixel text-vinho-soft text-lg mb-4">página em construção ♡</p>
        <p class="tape mb-4">⚠ work in progress ⚠</p>
        <.link navigate={~p"/mapa"} class="btn-y2k">← mapa</.link>
      </div>
    </main>
    """
  end
end
