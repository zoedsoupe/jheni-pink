defmodule SiteWeb.MapaLive do
  use SiteWeb, :live_view

  @rooms [
    %{path: "/quarto",  emoji: "♡",      label: "quarto"},
    %{path: "/cheer",   emoji: "📣",     label: "cheer"},
    %{path: "/psico",   emoji: "📚",     label: "psico"},
    %{path: "/menu",    emoji: "🍪",     label: "menu"},
    %{path: "/cartas",  emoji: "💌",     label: "cartas"},
    %{path: "/lesbica", emoji: "🏳️‍🌈",  label: "lésbica"},
    %{path: "/livro",   emoji: "✍️",     label: "livro"},
    %{path: "/links",   emoji: "🌐",     label: "links"},
    %{path: "/",        emoji: "🏠",     label: "splash"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "mapa do site ♡", rooms: @rooms)}
  end

  def render(assigns) do
    ~H"""
    <main class="bg-mapa min-h-screen px-4 py-6 pb-20">
      <header class="text-center mb-8">
        <h1 class="wordart text-5xl sm:text-6xl mb-2">jheni.pink</h1>
        <p class="font-pixel text-vinho text-lg">
          ∗ ⋆ ✧ ⋆ ∗ escolha sua aventura ∗ ⋆ ✧ ⋆ ∗
        </p>
      </header>

      <nav class="grid grid-1 sm:grid-2 lg:grid-3 gap-4 max-w-4xl mx-auto">
        <.link
          :for={room <- @rooms}
          navigate={room.path}
          class="mapa-tile border-4 border-vinho shadow-cute hover-lift p-6 text-center no-underline font-bubblegum text-2xl flex flex-col items-center justify-center"
        >
          <span class="block text-5xl mb-2 leading-none">{room.emoji}</span>
          {room.label}
        </.link>
      </nav>

      <footer class="font-pixel text-vinho-soft text-center mt-10 text-sm leading-relaxed">
        <p>♡ visitante #00042 ♡</p>
        <p>made with much love por sua morceguinho 🦇</p>
      </footer>
    </main>
    """
  end
end
