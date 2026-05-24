defmodule SiteWeb.CheerLive do
  use SiteWeb, :live_view

  @campeonatos [
    %{
      data: "25/10/2025",
      local: "Riocentro - RJ",
      time: "Winter (nível 2)",
      hora: "13h16"
    },
    %{
      data: "25/10/2025",
      local: "Riocentro - RJ",
      time: "Knight (nível 3)",
      hora: "15h00"
    }
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "cheer")
     |> assign(campeonatos: @campeonatos)}
  end

  def render(assigns) do
    ~H"""
    <main class="bg-cheer min-h-screen px-4 py-6 pb-20">
      <div class="max-w-3xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <div class="flex justify-center gap-4 mb-2">
            <span class="gif-bounce text-5xl font-pixel text-pink">\\o/</span>
            <span class="gif-bounce text-5xl font-pixel text-sunset-orange" style="animation-delay: 0.3s">\\o/</span>
            <span class="gif-bounce text-5xl font-pixel text-mostarda" style="animation-delay: 0.6s">\\o/</span>
          </div>
          <h1 class="wordart text-4xl sm:text-5xl mb-2">cheer cheer cheer</h1>
          <p class="font-pixel text-vinho-soft text-lg">~*~ go go go ~*~</p>
        </header>

        <div class="bg-mostarda text-vinho py-2 border-4 border-vinho shadow-cute mb-6 marquee">
          <span class="marquee-inner font-bubblegum text-xl">
            *~*~* READY? OK! *~*~* 5-6-7-8 *~*~* all-star competitivo *~*~* equipe é família *~*~* Riocentro 2025 *~*~*
          </span>
        </div>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">stats da atleta</h2>
          <dl class="grid grid-stats gap-2 text-base">
            <dt class="font-bubblegum text-sunset-rose">modalidade</dt>
            <dd>all-star</dd>
            <dt class="font-bubblegum text-sunset-rose">nível 2</dt>
            <dd>Winter team</dd>
            <dt class="font-bubblegum text-sunset-rose">nível 3</dt>
            <dd>Knight team</dd>
            <dt class="font-bubblegum text-sunset-rose">posição</dt>
            <dd>flyer / base (depende do stunt)</dd>
            <dt class="font-bubblegum text-sunset-rose">treina</dt>
            <dd>várias vezes na semana, sem dor sem ganho</dd>
          </dl>
        </section>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">campeonatos</h2>
          <ul class="flex flex-col gap-3">
            <li :for={c <- @campeonatos} class="px-4 py-3 border-l-4 border-sunset-rose bg-bubblegum">
              <div class="font-bubblegum text-vinho text-xl">{c.time}</div>
              <div class="font-pixel text-vinho-soft text-base">{c.data} -- {c.local}</div>
              <div class="font-pixel text-sunset-rose text-base">competiu às {c.hora}</div>
            </li>
          </ul>
        </section>

        <section class="bg-sunset-gradient border-4 border-vinho shadow-cute p-6 text-center mb-6">
          <h2 class="font-bubblegum text-cream text-3xl mb-3">minha equipe</h2>
          <p class="font-comic text-cream text-lg leading-relaxed">
            equipe é família. a gente cai junto, levanta junto, ganha junto e
            chora junto. obrigada por cada stunt, cada grito, cada abraço
            depois da apresentação.
          </p>
          <p class="font-pixel text-cream text-2xl mt-4">[ Winter &lt;3 Knight ]</p>
        </section>

        <section class="card-y2k text-center">
          <h2 class="font-bubblegum text-pink text-2xl mb-3">pom-pom show</h2>
          <pre class="font-pixel text-sunset-rose text-lg leading-tight inline-block text-left">     *  *  *  *  *
      \\o/  \\o/  \\o/
      /|\\  /|\\  /|\\
      / \\  / \\  / \\
     *  *  *  *  *</pre>
          <p class="font-pixel text-vinho-soft mt-3">arquibancada lotada (de zoey)</p>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
