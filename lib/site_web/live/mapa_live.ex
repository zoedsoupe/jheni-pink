defmodule SiteWeb.MapaLive do
  use SiteWeb, :live_view

  @rooms [
    %{path: "/quarto",  icon: "[ <3 ]", label: "quarto"},
    %{path: "/diario",  icon: ">>>",    label: "diário"},
    %{path: "/cheer",   icon: "\\o/",   label: "cheer"},
    %{path: "/psico",   icon: "[ B ]",  label: "psico"},
    %{path: "/menu",    icon: "( O )",  label: "menu"},
    %{path: "/cartas",  icon: "[ @ ]",  label: "cartas"},
    %{path: "/lesbica", icon: "=====",  label: "lésbica"},
    %{path: "/livro",   icon: "[ i ]",  label: "livro"},
    %{path: "/links",   icon: "<=>",    label: "links"},
    %{path: "/",        icon: "~ * ~",  label: "splash"}
  ]

  def mount(_params, _session, socket) do
    visits = Site.Stats.get_visits()

    {:ok,
     assign(socket,
       page_title: "mapa do site",
       rooms: @rooms,
       visits: Site.Stats.format_visits(visits)
     )}
  end

  def render(assigns) do
    ~H"""
    <main class="bg-mapa min-h-screen px-4 py-6 pb-20">
      <header class="text-center mb-8">
        <h1 class="wordart text-5xl sm:text-6xl mb-2">jheni.pink</h1>
        <p class="font-pixel text-vinho text-lg">
          *~* escolha sua aventura *~*
        </p>
      </header>

      <nav class="grid grid-1 sm:grid-2 lg:grid-3 gap-4 max-w-4xl mx-auto">
        <.link
          :for={room <- @rooms}
          navigate={room.path}
          class="mapa-tile border-4 border-vinho shadow-cute hover-lift p-6 text-center no-underline font-bubblegum text-2xl flex flex-col items-center justify-center"
        >
          <span class="block text-3xl mb-2 leading-none font-pixel">{room.icon}</span>
          {room.label}
        </.link>
      </nav>

      <footer class="font-pixel text-vinho-soft text-center mt-10 text-sm leading-relaxed">
        <p>visitante número {@visits}</p>
        <p>feito com muito amor pela sua raposinha</p>
      </footer>
    </main>
    """
  end
end
