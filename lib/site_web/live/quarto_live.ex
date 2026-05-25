defmodule SiteWeb.QuartoLive do
  use SiteWeb, :live_view
  use SiteWeb.RoomEditor, room: "quarto"

  import SiteWeb.RoomEditor, only: [editable: 1]

  def mount(_params, _session, socket) do
    if connected?(socket), do: Site.Rooms.subscribe()

    {:ok,
     socket
     |> assign(
       page_title: "quarto",
       dias_aniversario: dias_pro_aniversario(),
       editing_key: nil,
       raw_block: nil
     )
     |> assign_content()}
  end

  defp assign_content(socket) do
    assign(socket,
      subtitle: Site.Rooms.value(@room, "subtitle", default_for("subtitle")),
      marquee: Site.Rooms.value(@room, "marquee", default_for("marquee")),
      bio: Site.Rooms.value(@room, "bio", default_for("bio")),
      top5: Site.Rooms.value(@room, "top5", default_for("top5")),
      stats: Site.Rooms.value(@room, "stats", default_for("stats")),
      humor: Site.Rooms.value(@room, "humor", default_for("humor"))
    )
  end

  defp default_for("subtitle"), do: "~*~ bem-vinda à minha salinha ~*~"

  defp default_for("marquee") do
    "*~*~* bem-vinda ao meu quarto *~*~* não mexe nas minhas coisas *~*~* fica à vontade *~*~* beijinhos *~*~*"
  end

  defp default_for("bio") do
    """
    oi, sou a Jhene! moro em Campos onde estudo psicologia na UFF. nas férias volto pra Manhuaçu, onde minha mãe me espera.

    cheerleader nas horas vagas - faço all-star competitivo. já competi até no Riocentro.

    tenho um stack de mulheres pra discutir: Butler, Wittig, Beauvoir, Gayle Rubin, Deleuze e Guattari.
    """
    |> String.trim()
  end

  defp default_for("top5") do
    """
    zoey
    mãe
    o time de cheer todo
    Djavan
    """
    |> String.trim()
  end

  defp default_for("stats") do
    """
    nome | jhene
    cidade | Manhuaçu / Campos
    curso | Psicologia UFF
    cheer | all-star nível 2 + 3
    é | lésbica
    """
    |> String.trim()
  end

  defp default_for("humor"), do: "=^_^="
  defp default_for(_), do: ""

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
          <.editable
            id="quarto-subtitle"
            key="subtitle"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={2}
            hint="o subtítulo em cima do quarto"
          >
            <p class="font-pixel text-vinho-soft text-base">{@subtitle}</p>
          </.editable>
        </header>

        <div class="bg-pink text-cream py-2 border-4 border-vinho shadow-cute mb-6">
          <.editable
            id="quarto-marquee"
            key="marquee"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={3}
            hint="texto que passa rolando no topo"
          >
            <div class="marquee">
              <span class="marquee-inner font-bubblegum text-xl">{@marquee}</span>
            </div>
          </.editable>
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
              <.editable
                id="quarto-stats"
                key="stats"
                authed={@jhene_authorized}
                editing_key={@editing_key}
                raw={@raw_block}
                rows={8}
                hint="uma linha por par. formato: chave | valor"
              >
                <dl class="grid grid-stats gap-1 text-base">
                  <%= for {k, v} <- Site.Rooms.pairs(@stats) do %>
                    <dt class="font-bubblegum text-sunset-rose">{k}</dt>
                    <dd>{v}</dd>
                  <% end %>
                </dl>
              </.editable>
            </section>

            <section class="bg-mostarda border-3 border-dashed border-vinho p-4 text-center">
              <span class="font-pixel text-vinho text-base block mb-1">humor atual</span>
              <.editable
                id="quarto-humor"
                key="humor"
                authed={@jhene_authorized}
                editing_key={@editing_key}
                raw={@raw_block}
                rows={2}
                hint="emoticon do dia"
              >
                <span class="block text-4xl leading-none font-pixel">{@humor}</span>
              </.editable>
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
              <.editable
                id="quarto-bio"
                key="bio"
                authed={@jhene_authorized}
                editing_key={@editing_key}
                raw={@raw_block}
                rows={8}
                hint="parágrafos separados por linha em branco"
              >
                <div class="leading-relaxed text-base flex flex-col gap-3">
                  <p :for={para <- Site.Rooms.paragraphs(@bio)}>{para}</p>
                  <p>
                    <.link navigate={~p"/psico"}>vai pra estante &gt;&gt;</.link>
                  </p>
                </div>
              </.editable>
            </article>

            <article class="card-y2k">
              <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">top 5</h2>
              <.editable
                id="quarto-top5"
                key="top5"
                authed={@jhene_authorized}
                editing_key={@editing_key}
                raw={@raw_block}
                rows={6}
                hint="um item por linha"
              >
                <ul class="flex flex-col gap-2">
                  <li :for={item <- Site.Rooms.lines(@top5)} class="px-3 py-2 border-l-4 border-musgo bg-menta">
                    {item}
                  </li>
                </ul>
              </.editable>
            </article>
          </section>
        </div>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
