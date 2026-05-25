defmodule SiteWeb.MapaLive do
  use SiteWeb, :live_view
  use SiteWeb.RoomEditor, room: "mapa"

  import SiteWeb.RoomEditor, only: [editable: 1]

  def mount(_params, _session, socket) do
    if connected?(socket), do: Site.Rooms.subscribe()

    visits = Site.Stats.get_visits()

    {:ok,
     socket
     |> assign(
       page_title: "mapa do site",
       visits: Site.Stats.format_visits(visits),
       editing_key: nil,
       raw_block: nil
     )
     |> assign_content()}
  end

  defp assign_content(socket) do
    raw_tiles = Site.Rooms.value(@room, "tiles", default_for("tiles"))

    assign(socket,
      subtitle: Site.Rooms.value(@room, "subtitle", default_for("subtitle")),
      footer: Site.Rooms.value(@room, "footer", default_for("footer")),
      tiles_raw: raw_tiles,
      tiles: Site.Rooms.records(raw_tiles)
    )
  end

  defp default_for("subtitle"), do: "*~* escolha sua aventura *~*"
  defp default_for("footer"), do: "feito com muito amor pela tua zoeyrinha"

  defp default_for("tiles") do
    """
    path: /quarto
    icon: [ <3 ]
    label: quarto

    path: /diario
    icon: >>>
    label: diário

    path: /cheer
    icon: \\o/
    label: cheer

    path: /psico
    icon: [ B ]
    label: psico

    path: /menu
    icon: ( O )
    label: menu

    path: /cartas
    icon: [ @ ]
    label: cartas

    path: /lesbica
    icon: =====
    label: lésbica

    path: /livro
    icon: [ i ]
    label: livro

    path: /links
    icon: <=>
    label: links

    path: /album
    icon: ( o o )
    label: album

    path: /
    icon: ~ * ~
    label: splash
    """
    |> String.trim()
  end

  defp default_for(_), do: ""

  def render(assigns) do
    ~H"""
    <main class="bg-mapa min-h-screen px-4 py-6 pb-20">
      <header class="text-center mb-8">
        <h1 class="wordart text-5xl sm:text-6xl mb-2">jhene</h1>
        <.editable
          id="mapa-subtitle"
          key="subtitle"
          authed={@jhene_authorized}
          editing_key={@editing_key}
          raw={@raw_block}
          rows={2}
          align="center"
        >
          <p class="font-pixel text-vinho text-lg">{@subtitle}</p>
        </.editable>
      </header>

      <nav class="grid grid-1 sm:grid-2 lg:grid-3 gap-4 max-w-4xl mx-auto">
        <.link
          :for={room <- @tiles}
          navigate={room["path"]}
          class="mapa-tile border-4 border-vinho shadow-cute hover-lift p-6 text-center no-underline font-bubblegum text-2xl flex flex-col items-center justify-center"
        >
          <span class="block text-3xl mb-2 leading-none font-pixel">{room["icon"]}</span>
          {room["label"]}
        </.link>
      </nav>

      <section :if={@jhene_authorized} class="max-w-4xl mx-auto mt-8">
        <div class="card-y2k">
          <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            caixinhas do mapa
          </h2>
          <.editable
            id="mapa-tiles"
            key="tiles"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={28}
            hint="cada tile: 'path:', 'icon:', 'label:' separados por linha em branco. ordem aqui = ordem no mapa."
            template={"path: \nicon: \nlabel: "}
            add_label="+ novo tile"
          >
            <p class="font-pixel text-vinho-soft text-base">
              [ {length(@tiles)} caixinhas cadastradas -- clica em editar pra mudar nomes, emoticons ou ordem ]
            </p>
          </.editable>
        </div>
      </section>

      <footer class="font-pixel text-vinho-soft text-center mt-10 text-sm leading-relaxed">
        <p>visitante número {@visits}</p>
        <.editable
          id="mapa-footer"
          key="footer"
          authed={@jhene_authorized}
          editing_key={@editing_key}
          raw={@raw_block}
          rows={2}
          hint="assinatura no rodapé"
          align="center"
        >
          <p>{@footer}</p>
        </.editable>
      </footer>
    </main>
    """
  end
end
