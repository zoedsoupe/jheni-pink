defmodule SiteWeb.LesbicaLive do
  use SiteWeb, :live_view

  @ancestrais [
    %{
      nome: "Monique Wittig",
      tag: "francesa, 1935-2003",
      por_que: "O Pensamento Hetero. O Corpo Lesbico. lesbicas nao sao mulheres."
    },
    %{
      nome: "Audre Lorde",
      tag: "americana, 1934-1992",
      por_que: "poeta, negra, lesbica, mae. Sister Outsider. o erotico como poder."
    },
    %{
      nome: "Gloria Anzaldua",
      tag: "chicana, 1942-2004",
      por_que: "Borderlands/La Frontera. fronteira como corpo, corpo como fronteira."
    },
    %{
      nome: "Cassandra Rios",
      tag: "brasileira, 1932-2002",
      por_que: "primeira lesbica best-seller do Brasil. censurada pela ditadura. heroina."
    },
    %{
      nome: "Pagu (Patricia Galvao)",
      tag: "brasileira, 1910-1962",
      por_que: "comunista, escritora, presa, modernista. parque industrial."
    }
  ]

  @recs %{
    livros: [
      "O Corpo Lesbico -- Monique Wittig",
      "Stone Butch Blues -- Leslie Feinberg",
      "Carol -- Patricia Highsmith",
      "Sister Outsider -- Audre Lorde"
    ],
    filmes: [
      "Carol (2015)",
      "Retrato de uma jovem em chamas (2019)",
      "Disobedience (2017)",
      "But I'm a Cheerleader (1999)"
    ],
    musicas: [
      "Ana Vitoria -- discografia inteira",
      "Joao -- Supernova",
      "girl in red -- tudo",
      "Tegan and Sara -- tudo"
    ]
  }

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "lesbica")
     |> assign(ancestrais: @ancestrais)
     |> assign(recs: @recs)}
  end

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
          <h1 class="wordart-sunset text-4xl sm:text-6xl mb-2">lesbica</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* bandeira ao alto, peito aberto *~*
          </p>
        </header>

        <div class="bg-sunset-rose text-cream py-2 border-4 border-vinho shadow-cute mb-6 marquee">
          <span class="marquee-inner font-bubblegum text-xl">
            *~*~* monogamicas, monogamicas everywhere *~*~* mas nem uma gota pra namorar *~*~* (Shay, II Coloquio, palestrante linda + monogamica rsrs) *~*~*
          </span>
        </div>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-sunset-rose text-3xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            manifesto pequenininho
          </h2>
          <p class="font-comic text-vinho text-base leading-relaxed">
            ser lesbica nao e so quem a gente ama -- e como a gente olha pro
            mundo. e construir afeto fora do roteiro pronto, inventar familia
            onde nao tinha, levar a serio o desejo das mulheres por mulheres
            como ponto de partida e nao parentese. e bandeira, mas tambem e
            sofa de domingo. e politica, mas tambem e bilhete na geladeira.
            e estar viva no proprio corpo, sem pedir licenca pra ninguem.
          </p>
        </section>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-sunset-rose text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">
            ancestrais
          </h2>
          <ul class="flex flex-col gap-4">
            <li :for={a <- @ancestrais} class="border-l-4 border-sunset-orange pl-4 py-1">
              <div class="font-bubblegum text-pink text-xl">{a.nome}</div>
              <div class="font-pixel text-vinho-soft text-base">[ {a.tag} ]</div>
              <div class="font-comic text-vinho text-base mt-1">{a.por_que}</div>
            </li>
          </ul>
        </section>

        <section class="grid grid-1 sm:grid-3 gap-4 mb-6">
          <div class="card-y2k">
            <h3 class="font-bubblegum text-pink text-xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
              livros
            </h3>
            <ul class="font-comic text-vinho text-base flex flex-col gap-2">
              <li :for={item <- @recs.livros}>- {item}</li>
            </ul>
          </div>

          <div class="card-y2k">
            <h3 class="font-bubblegum text-pink text-xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
              filmes
            </h3>
            <ul class="font-comic text-vinho text-base flex flex-col gap-2">
              <li :for={item <- @recs.filmes}>- {item}</li>
            </ul>
          </div>

          <div class="card-y2k">
            <h3 class="font-bubblegum text-pink text-xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
              musicas
            </h3>
            <ul class="font-comic text-vinho text-base flex flex-col gap-2">
              <li :for={item <- @recs.musicas}>- {item}</li>
            </ul>
          </div>
        </section>

        <section class="bg-sunset-gradient border-4 border-vinho shadow-cute p-6 text-center">
          <p class="font-bubblegum text-cream text-2xl">
            o mundo seria melhor com mais lesbicas
          </p>
          <p class="font-pixel text-cream text-base mt-2">
            -- gente serie A, certeza
          </p>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
