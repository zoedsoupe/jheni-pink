defmodule SiteWeb.CheerLive do
  use SiteWeb, :live_view
  use SiteWeb.RoomEditor, room: "cheer"

  import SiteWeb.RoomEditor, only: [editable: 1]

  def mount(_params, _session, socket) do
    if connected?(socket), do: Site.Rooms.subscribe()

    {:ok,
     socket
     |> assign(
       page_title: "cheer",
       editing_key: nil,
       raw_block: nil
     )
     |> assign_content()}
  end

  defp assign_content(socket) do
    assign(socket,
      marquee: Site.Rooms.value(@room, "marquee", default_for("marquee")),
      stats: Site.Rooms.value(@room, "stats", default_for("stats")),
      campeonatos: Site.Rooms.value(@room, "campeonatos", default_for("campeonatos"))
    )
  end

  defp default_for("marquee") do
    "*~*~* READY? OK! *~*~* 5-6-7-8 *~*~* all-star competitivo *~*~* Riocentro 2025 *~*~*"
  end

  defp default_for("stats") do
    """
    modalidade | all-star
    atua em | partner stunt + equipe all-girl
    níveis | 2 e 3
    """
    |> String.trim()
  end

  defp default_for("campeonatos") do
    """
    evento: Riocentro
    data: 25/10/2025
    local: RJ
    categoria: nível 2 (all girl)
    hora: 13h16

    evento: Riocentro
    data: 25/10/2025
    local: RJ
    categoria: nível 3
    hora: 15h00

    evento: Campeonato de partner stunt
    data: 22/11/2025
    local: RJ
    categoria: partner stunt -- ganhou medalha
    hora: dia todo
    """
    |> String.trim()
  end

  defp default_for(_), do: ""

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

        <div class="bg-mostarda text-vinho py-2 border-4 border-vinho shadow-cute mb-6">
          <.editable
            id="cheer-marquee"
            key="marquee"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={3}
          >
            <div class="marquee">
              <span class="marquee-inner font-bubblegum text-xl">{@marquee}</span>
            </div>
          </.editable>
        </div>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">stats da atleta</h2>
          <.editable
            id="cheer-stats"
            key="stats"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={6}
            hint="uma linha por par. formato: chave | valor"
          >
            <dl class="grid grid-stats gap-2 text-base">
              <%= for {k, v} <- Site.Rooms.pairs(@stats) do %>
                <dt class="font-bubblegum text-sunset-rose">{k}</dt>
                <dd>{v}</dd>
              <% end %>
            </dl>
          </.editable>
        </section>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">campeonatos</h2>
          <.editable
            id="cheer-campeonatos"
            key="campeonatos"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={14}
            hint="cada campeonato: linhas 'evento:', 'data:', 'local:', 'categoria:', 'hora:' separadas por linha em branco"
          >
            <ul class="flex flex-col gap-3">
              <li :for={c <- Site.Rooms.records(@campeonatos)} class="px-4 py-3 border-l-4 border-sunset-rose bg-bubblegum">
                <div class="font-bubblegum text-vinho text-xl">{c["evento"]} -- {c["categoria"]}</div>
                <div class="font-pixel text-vinho-soft text-base">{c["data"]} -- {c["local"]}</div>
                <div class="font-pixel text-sunset-rose text-base">competiu às {c["hora"]}</div>
              </li>
            </ul>
          </.editable>
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
