defmodule SiteWeb.PsicoLive do
  use SiteWeb, :live_view

  @estante [
    %{
      area: "Fenomenologia",
      cor: "bg-bubblegum",
      autores: [
        %{nome: "Edmund Husserl", obra: "Investigações Lógicas / Ideias"},
        %{nome: "Maurice Merleau-Ponty", obra: "Fenomenologia da Percepção"},
        %{nome: "Martin Heidegger", obra: "Ser e Tempo"}
      ]
    },
    %{
      area: "Gênero & Sexualidade",
      cor: "bg-menta",
      autores: [
        %{nome: "Judith Butler", obra: "Problemas de Gênero / Corpos que Importam"},
        %{nome: "Monique Wittig", obra: "O Pensamento Hetero / O Corpo Lésbico"},
        %{nome: "Simone de Beauvoir", obra: "O Segundo Sexo"},
        %{nome: "Gayle Rubin", obra: "Pensando o Sexo / Tráfego de Mulheres"}
      ]
    },
    %{
      area: "Filosofia da Diferença",
      cor: "bg-mostarda",
      autores: [
        %{nome: "Gilles Deleuze & Felix Guattari", obra: "Mil Platôs / Anti-Édipo"}
      ]
    }
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "psico - a estante")
     |> assign(estante: @estante)}
  end

  def render(assigns) do
    ~H"""
    <main class="bg-psico min-h-screen px-4 py-6 pb-20">
      <div class="max-w-4xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-5xl block mb-2 text-vinho">[ B ]</span>
          <h1 class="wordart-pink text-4xl sm:text-5xl mb-2">a estante</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* psicologia, filosofia e gente que pensa o corpo *~*
          </p>
        </header>

        <div class="bg-sunset-rose text-cream py-2 border-4 border-vinho shadow-cute mb-6 marquee">
          <span class="marquee-inner font-bubblegum text-xl">
            *~* o corpo não mente *~* o sexo não é natural *~* o gênero é performativo *~* devir mulher devir lésbica *~* fenomenologia é meu lugar feliz *~*
          </span>
        </div>

        <section :for={prat <- @estante} class="card-y2k mb-6">
          <h2 class={"font-bubblegum text-vinho text-2xl sm:text-3xl mb-4 px-3 py-2 border-3 border-vinho inline-block #{prat.cor}"}>
            {prat.area}
          </h2>
          <ul class="flex flex-col gap-3">
            <li :for={a <- prat.autores} class="border-l-4 border-pink pl-3 py-1">
              <div class="font-bubblegum text-pink text-xl">{a.nome}</div>
              <div class="font-pixel text-vinho-soft text-base">{a.obra}</div>
            </li>
          </ul>
        </section>

        <section class="bg-sunset-gradient border-4 border-vinho shadow-cute p-6 mb-6">
          <h2 class="font-bubblegum text-cream text-3xl mb-2">
            II Colóquio de Fenomenologia Clínica
          </h2>
          <p class="font-pixel text-cream text-lg mb-2">21-22 de maio de 2026 -- UFF Campos</p>
          <p class="font-comic text-cream text-base leading-relaxed">
            dois dias de palestra, mesa redonda e gente brilhante falando de
            corpo, clínica e mundo-vivido. saí de lá com a cabeça cheia e o
            caderno mais cheio ainda. Husserl seria a primeira pessoa na
            festa.
          </p>
          <p class="font-pixel text-mostarda text-base mt-3">[ registro #001 ]</p>
        </section>

        <section class="card-y2k">
          <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            agora lendo
          </h2>
          <p class="font-comic text-vinho text-base leading-relaxed">
            esse cantinho fica reservado pro livro do mês -- ainda em obra
            mas em breve com resenha curtinha sobre o que tá na mesa de
            cabeceira.
          </p>
          <p class="font-pixel text-sunset-rose text-base mt-2">[ to-do: jhene recomenda ]</p>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
