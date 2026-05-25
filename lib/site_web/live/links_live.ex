defmodule SiteWeb.LinksLive do
  use SiteWeb, :live_view
  use SiteWeb.RoomEditor, room: "links"

  import SiteWeb.RoomEditor, only: [editable: 1]

  def mount(_params, _session, socket) do
    if connected?(socket), do: Site.Rooms.subscribe()

    {:ok,
     socket
     |> assign(
       page_title: "links",
       editing_key: nil,
       raw_block: nil
     )
     |> assign_content()}
  end

  defp assign_content(socket) do
    assign(socket,
      marquee: Site.Rooms.value(@room, "marquee", default_for("marquee")),
      musicas: Site.Rooms.value(@room, "musicas", default_for("musicas")),
      sites: Site.Rooms.value(@room, "sites", default_for("sites"))
    )
  end

  defp default_for("marquee") do
    "*~*~* fone no máximo *~*~* aba do navegador sempre aberta *~*~* clica que abre em outra janela *~*~*"
  end

  defp default_for("musicas") do
    """
    artista: Jão
    album: Supernova
    vibe: álbum que mora no replay
    url: https://open.spotify.com/album/3MN8yWquVuWoOM0DOLRXsf?si=d1b57357b3254967

    artista: Ana Vitória
    album: discografia inteira
    vibe: voz que abraça, show dia 05/06
    url: https://open.spotify.com/search/Ana%20Vitoria

    artista: Baco Exu do Blues
    album: Bluesman + tudo o resto
    vibe: letra que é tese, beat que é soco
    url: https://open.spotify.com/search/Baco%20Exu%20do%20Blues
    """
    |> String.trim()
  end

  defp default_for("sites") do
    """
    nome: meu insta
    url: https://instagram.com/sweet.jhee
    desc: meu diario fotografico
    """
    |> String.trim()
  end

  defp default_for(_), do: ""

  def render(assigns) do
    ~H"""
    <main class="bg-links min-h-screen px-4 py-6 pb-20">
      <div class="max-w-3xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-5xl block mb-2 text-pink">&lt;=&gt;</span>
          <h1 class="wordart text-4xl sm:text-5xl mb-2">os links</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* música + sites + tudo que eu salvo *~*
          </p>
        </header>

        <div class="bg-limao text-vinho py-2 border-4 border-vinho shadow-cute mb-6">
          <.editable
            id="links-marquee"
            key="marquee"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={3}
            align="center"
          >
            <div class="marquee">
              <span class="marquee-inner font-bubblegum text-xl">{@marquee}</span>
            </div>
          </.editable>
        </div>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">
            playlist sagrada
          </h2>
          <.editable
            id="links-musicas"
            key="musicas"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={16}
            hint="cada música: 'artista:', 'album:', 'vibe:', 'url:' separadas das próximas por linha em branco"
            template="artista: \nalbum: \nvibe: \nurl: "
            add_label="+ nova música"
          >
            <ul class="flex flex-col gap-4">
              <li
                :for={m <- Site.Rooms.records(@musicas)}
                class="border-3 border-vinho bg-bubblegum p-4 shadow-cute hover-lift"
              >
                <a href={m["url"]} target="_blank" rel="noopener" class="no-underline">
                  <div class="font-bubblegum text-pink text-2xl">{m["artista"]}</div>
                  <div class="font-pixel text-vinho text-base">[ {m["album"]} ]</div>
                  <div class="font-comic text-vinho-soft text-base mt-1">{m["vibe"]}</div>
                  <div class="font-pixel text-sunset-rose text-base mt-2">
                    --&gt; abrir no spotify
                  </div>
                </a>
              </li>
            </ul>
          </.editable>
        </section>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">
            sites que eu visito
          </h2>
          <.editable
            id="links-sites"
            key="sites"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={14}
            hint="cada site: 'nome:', 'url:', 'desc:' separadas das próximas por linha em branco"
            template="nome: \nurl: \ndesc: "
            add_label="+ novo site"
          >
            <ul class="flex flex-col gap-3">
              <li
                :for={s <- Site.Rooms.records(@sites)}
                class="border-l-4 border-musgo bg-menta px-4 py-3"
              >
                <a href={s["url"]} target="_blank" rel="noopener" class="no-underline">
                  <div class="font-bubblegum text-vinho text-xl">{s["nome"]}</div>
                  <div class="font-pixel text-vinho-soft text-base">{s["desc"]}</div>
                </a>
              </li>
            </ul>
          </.editable>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
