defmodule SiteWeb.LinksLive do
  use SiteWeb, :live_view

  @musicas [
    %{
      artista: "Joao",
      album: "Supernova",
      vibe: "album que mora no replay",
      url: "https://open.spotify.com/search/Joao%20Supernova"
    },
    %{
      artista: "Ana Vitoria",
      album: "discografia inteira",
      vibe: "voz que abraca, show dia 05/06",
      url: "https://open.spotify.com/search/Ana%20Vitoria"
    },
    %{
      artista: "Baco Exu do Blues",
      album: "Bluesman + tudo o resto",
      vibe: "letra que e tese, beat que e soco",
      url: "https://open.spotify.com/search/Baco%20Exu%20do%20Blues"
    }
  ]

  @sites_favoritos [
    %{nome: "neocities.org", url: "https://neocities.org", desc: "internet de antigamente"},
    %{nome: "are.na", url: "https://are.na", desc: "mood board sem algoritmo"},
    %{nome: "ASCII art archive", url: "https://www.asciiart.eu/", desc: "fonte de inspiracao infinita"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "links")
     |> assign(musicas: @musicas)
     |> assign(sites: @sites_favoritos)}
  end

  def render(assigns) do
    ~H"""
    <main class="bg-links min-h-screen px-4 py-6 pb-20">
      <div class="max-w-3xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-5xl block mb-2 text-pink">&lt;=&gt;</span>
          <h1 class="wordart text-4xl sm:text-5xl mb-2">os links</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* musica + sites + tudo que eu salvo *~*
          </p>
        </header>

        <div class="bg-limao text-vinho py-2 border-4 border-vinho shadow-cute mb-6 marquee">
          <span class="marquee-inner font-bubblegum text-xl">
            *~*~* fone no maximo *~*~* aba do navegador sempre aberta *~*~* clica que abre em outra janela *~*~*
          </span>
        </div>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">
            playlist sagrada
          </h2>
          <ul class="flex flex-col gap-4">
            <li :for={m <- @musicas} class="border-3 border-vinho bg-bubblegum p-4 shadow-cute hover-lift">
              <a href={m.url} target="_blank" rel="noopener" class="no-underline">
                <div class="font-bubblegum text-pink text-2xl">{m.artista}</div>
                <div class="font-pixel text-vinho text-base">[ {m.album} ]</div>
                <div class="font-comic text-vinho-soft text-base mt-1">{m.vibe}</div>
                <div class="font-pixel text-sunset-rose text-base mt-2">--&gt; abrir no spotify</div>
              </a>
            </li>
          </ul>
          <p class="font-pixel text-vinho-soft text-base mt-4 text-center">
            [ embed real do spotify em breve, por enquanto: clica que abre ]
          </p>
        </section>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">
            sites que eu visito
          </h2>
          <ul class="flex flex-col gap-3">
            <li :for={s <- @sites} class="border-l-4 border-musgo bg-menta px-4 py-3">
              <a href={s.url} target="_blank" rel="noopener" class="no-underline">
                <div class="font-bubblegum text-vinho text-xl">{s.nome}</div>
                <div class="font-pixel text-vinho-soft text-base">{s.desc}</div>
              </a>
            </li>
          </ul>
        </section>

        <section class="bg-sunset-gradient border-4 border-vinho shadow-cute p-6 text-center">
          <p class="font-bubblegum text-cream text-2xl mb-2">powered by ASCII + amor</p>
          <p class="font-pixel text-cream text-base">[ &lt;3 ] [ &lt;3 ] [ &lt;3 ]</p>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
