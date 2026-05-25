defmodule SiteWeb.LesbicaLive do
  use SiteWeb, :live_view
  use SiteWeb.RoomEditor, room: "lesbica"

  import SiteWeb.RoomEditor, only: [editable: 1]

  def mount(_params, _session, socket) do
    if connected?(socket), do: Site.Rooms.subscribe()

    {:ok,
     socket
     |> assign(
       page_title: "lésbica",
       editing_key: nil,
       raw_block: nil
     )
     |> assign_content()}
  end

  defp assign_content(socket) do
    assign(socket,
      marquee: Site.Rooms.value(@room, "marquee", default_for("marquee")),
      manifesto: Site.Rooms.value(@room, "manifesto", default_for("manifesto")),
      ancestrais: Site.Rooms.value(@room, "ancestrais", default_for("ancestrais")),
      livros: Site.Rooms.value(@room, "livros", default_for("livros")),
      filmes: Site.Rooms.value(@room, "filmes", default_for("filmes")),
      musicas: Site.Rooms.value(@room, "musicas", default_for("musicas"))
    )
  end

  defp default_for("marquee") do
    "*~*~* o futuro é sáfico *~*~* lésbica é palavra de bandeira *~*~* mulher amando mulher sem pedir licença *~*~* nossas ancestrais resistiram, a gente continua *~*~* visibilidade lésbica todo dia *~*~*"
  end

  defp default_for("manifesto") do
    """
    ser lésbica não é só quem a gente ama -- é como a gente olha pro
    mundo. é construir afeto fora do roteiro pronto, inventar família
    onde não tinha, levar a sério o desejo das mulheres por mulheres
    como ponto de partida e não parêntese. é bandeira, mas também é
    sofá de domingo. é política, mas também é bilhete na geladeira.
    é estar viva no próprio corpo, sem pedir licença pra ninguém.
    """
    |> String.trim()
  end

  defp default_for("ancestrais") do
    """
    nome: Monique Wittig
    tag: francesa, 1935-2003
    por_que: O Pensamento Hetero. O Corpo Lésbico. lésbicas não são mulheres.

    nome: Audre Lorde
    tag: americana, 1934-1992
    por_que: poeta, negra, lésbica, mãe. Sister Outsider. o erótico como poder.

    nome: Gloria Anzaldúa
    tag: chicana, 1942-2004
    por_que: Borderlands/La Frontera. fronteira como corpo, corpo como fronteira.

    nome: Cassandra Rios
    tag: brasileira, 1932-2002
    por_que: primeira lésbica best-seller do Brasil. censurada pela ditadura. heroína.

    nome: Pagu (Patrícia Galvão)
    tag: brasileira, 1910-1962
    por_que: comunista, escritora, presa, modernista. parque industrial.
    """
    |> String.trim()
  end

  defp default_for("livros") do
    """
    O Corpo Lésbico -- Monique Wittig
    Stone Butch Blues -- Leslie Feinberg
    Carol -- Patricia Highsmith
    Sister Outsider -- Audre Lorde
    """
    |> String.trim()
  end

  defp default_for("filmes") do
    """
    (recomendacoes)
    Carol (2015)
    Retrato de uma jovem em chamas (2019)
    Disobedience (2017)
    But I'm a Cheerleader (1999)
    """
    |> String.trim()
  end

  defp default_for("musicas") do
    """
    Ana Vitória -- discografia inteira
    Jão -- Supernova
    """
    |> String.trim()
  end

  defp default_for(_), do: ""

  def render(assigns) do
    ~H"""
    <main class="bg-lesbica min-h-screen px-4 py-6 pb-20">
      <div class="flex flex-col w-full mb-6">
        <div class="h-3 bg-sunset-orange"></div>
        <div class="h-3" style="background: var(--c-sunset-light-orange)"></div>
        <div class="h-3 bg-cream"></div>
        <div class="h-3 bg-sunset-pink"></div>
        <div class="h-3 bg-sunset-magenta"></div>
        <div class="h-3 bg-sunset-rose"></div>
      </div>

      <div class="max-w-3xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-3xl block mb-2 text-sunset-rose">===== ===== =====</span>
          <h1 class="wordart-sunset text-4xl sm:text-6xl mb-2">lésbica</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* bandeira ao alto, peito aberto *~*
          </p>
        </header>

        <div class="bg-sunset-rose text-cream py-2 border-4 border-vinho shadow-cute mb-6">
          <.editable
            id="lesbica-marquee"
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
          <h2 class="font-bubblegum text-sunset-rose text-3xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            manifesto pequenininho
          </h2>
          <.editable
            id="lesbica-manifesto"
            key="manifesto"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={10}
            hint="o manifesto -- parágrafos separados por linha em branco"
            template="novo parágrafo do manifesto"
            add_label="+ novo parágrafo"
          >
            <div class="font-comic text-vinho text-base leading-relaxed flex flex-col gap-3">
              <p :for={para <- Site.Rooms.paragraphs(@manifesto)}>{para}</p>
            </div>
          </.editable>
        </section>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-sunset-rose text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">
            ancestrais
          </h2>
          <.editable
            id="lesbica-ancestrais"
            key="ancestrais"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={20}
            hint="cada ancestral: 'nome:', 'tag:', 'por_que:' em três linhas, separadas das próximas por linha em branco"
            template="nome: \ntag: \npor_que: "
            add_label="+ nova ancestral"
          >
            <ul class="flex flex-col gap-4">
              <li
                :for={a <- Site.Rooms.records(@ancestrais)}
                class="border-l-4 border-sunset-orange pl-4 py-1"
              >
                <div class="font-bubblegum text-pink text-xl">{a["nome"]}</div>
                <div class="font-pixel text-vinho-soft text-base">[ {a["tag"]} ]</div>
                <div class="font-comic text-vinho text-base mt-1">{a["por_que"]}</div>
              </li>
            </ul>
          </.editable>
        </section>

        <section class="grid grid-1 sm:grid-3 gap-4 mb-6">
          <div class="card-y2k">
            <h3 class="font-bubblegum text-pink text-xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
              livros
            </h3>
            <.editable
              id="lesbica-livros"
              key="livros"
              authed={@jhene_authorized}
              editing_key={@editing_key}
              raw={@raw_block}
              rows={6}
              hint="um livro por linha"
              template="novo livro -- autora"
              add_label="+ livro"
            >
              <ul class="font-comic text-vinho text-base flex flex-col gap-2">
                <li :for={item <- Site.Rooms.lines(@livros)}>- {item}</li>
              </ul>
            </.editable>
          </div>

          <div class="card-y2k">
            <h3 class="font-bubblegum text-pink text-xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
              filmes
            </h3>
            <.editable
              id="lesbica-filmes"
              key="filmes"
              authed={@jhene_authorized}
              editing_key={@editing_key}
              raw={@raw_block}
              rows={6}
              hint="um filme por linha"
              template="novo filme (ano)"
              add_label="+ filme"
            >
              <ul class="font-comic text-vinho text-base flex flex-col gap-2">
                <li :for={item <- Site.Rooms.lines(@filmes)}>- {item}</li>
              </ul>
            </.editable>
          </div>

          <div class="card-y2k">
            <h3 class="font-bubblegum text-pink text-xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
              músicas
            </h3>
            <.editable
              id="lesbica-musicas"
              key="musicas"
              authed={@jhene_authorized}
              editing_key={@editing_key}
              raw={@raw_block}
              rows={6}
              hint="uma música/artista por linha"
              template="nova artista -- album"
              add_label="+ música"
            >
              <ul class="font-comic text-vinho text-base flex flex-col gap-2">
                <li :for={item <- Site.Rooms.lines(@musicas)}>- {item}</li>
              </ul>
            </.editable>
          </div>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
