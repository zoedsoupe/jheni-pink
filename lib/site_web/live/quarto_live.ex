defmodule SiteWeb.QuartoLive do
  use SiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "quarto")
     |> assign(dias_aniversario: dias_pro_aniversario())}
  end

  defp dias_pro_aniversario do
    today = Date.utc_today()
    target_year = if {today.month, today.day} >= {1, 3}, do: today.year + 1, else: today.year
    Date.diff(Date.new!(target_year, 1, 3), today)
  end

  def render(assigns) do
    ~H"""
    <main class="bg-quarto-stripes min-h-screen px-4 py-6 pb-20">
      <div class="max-w-4xl mx-auto">
        <header class="card-y2k text-center mb-4">
          <h1 class="wordart-pink text-4xl sm:text-5xl mb-2">o quarto</h1>
          <p class="font-pixel text-vinho-soft text-base">~*~ bem-vinda à minha salinha ~*~</p>
        </header>

        <div class="bg-pink text-cream py-2 border-4 border-vinho shadow-cute mb-6 marquee">
          <span class="marquee-inner font-bubblegum text-xl">
            *~*~* bem-vinda ao meu quarto *~*~* não mexe nas minhas coisas *~*~* alimenta o Simba *~*~* beijinhos *~*~*
          </span>
        </div>

        <div class="grid grid-1 md:grid-2 gap-4 md:items-start">
          <aside class="flex flex-col gap-4">
            <div class="photo-frame">
              <div class="photo-placeholder">
                foto<br />vai aqui :)
              </div>
            </div>

            <section class="card-y2k">
              <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">stats</h2>
              <dl class="grid grid-stats gap-1 text-base">
                <dt class="font-bubblegum text-sunset-rose">nome</dt>
                <dd>jhene</dd>
                <dt class="font-bubblegum text-sunset-rose">cidade</dt>
                <dd>Manhuaçu / Campos</dd>
                <dt class="font-bubblegum text-sunset-rose">curso</dt>
                <dd>Psicologia UFF</dd>
                <dt class="font-bubblegum text-sunset-rose">cheer</dt>
                <dd>all-star nível 2 + 3</dd>
                <dt class="font-bubblegum text-sunset-rose">gato</dt>
                <dd>Simba</dd>
                <dt class="font-bubblegum text-sunset-rose">é</dt>
                <dd>lésbica</dd>
              </dl>
            </section>

            <section class="bg-mostarda border-3 border-dashed border-vinho p-4 text-center">
              <span class="font-pixel text-vinho text-base block mb-1">humor atual</span>
              <span class="block text-4xl leading-none font-pixel">=^_^=</span>
            </section>

            <section class="bg-sunset-gradient border-3 border-vinho shadow-cute p-4 text-center">
              <span class="font-bubblegum text-base block">próximo aniversário</span>
              <span class="font-pixel text-4xl block mt-1 mb-1">{@dias_aniversario}</span>
              <span class="font-bubblegum text-sm block">dias até 3 de janeiro</span>
            </section>
          </aside>

          <section class="flex flex-col gap-4">
            <article class="card-y2k">
              <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">sobre mim</h2>
              <div class="leading-relaxed text-base flex flex-col gap-3">
                <p>oi, sou a Jhene! moro em Campos onde estudo psicologia na UFF. nas férias volto pra Manhuaçu, onde minha mãe e meu Simba me esperam.</p>
                <p>cheerleader nas horas vagas - faço all-star competitivo. já competi até no Riocentro.</p>
                <p>tenho um stack de mulheres pra discutir: Butler, Wittig, Beauvoir, Gayle Rubin, Deleuze e Guattari. <.link navigate={~p"/psico"}>vai pra estante &gt;&gt;</.link></p>
              </div>
            </article>

            <article class="card-y2k">
              <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">top 5</h2>
              <ul class="flex flex-col gap-2">
                <li class="px-3 py-2 border-l-4 border-musgo bg-menta">zoey</li>
                <li class="px-3 py-2 border-l-4 border-musgo bg-menta">Simba (o gato)</li>
                <li class="px-3 py-2 border-l-4 border-musgo bg-menta">mãe</li>
                <li class="px-3 py-2 border-l-4 border-musgo bg-menta">o time de cheer todo</li>
                <li class="px-3 py-2 border-l-4 border-musgo bg-menta">Djavan</li>
              </ul>
            </article>
          </section>
        </div>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
