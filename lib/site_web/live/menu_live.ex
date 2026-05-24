defmodule SiteWeb.MenuLive do
  use SiteWeb, :live_view
  use SiteWeb.RoomEditor, room: "menu"

  import SiteWeb.RoomEditor, only: [editable: 1]

  def mount(_params, _session, socket) do
    if connected?(socket), do: Site.Rooms.subscribe()

    {:ok,
     socket
     |> assign(
       page_title: "menu da jhene",
       editing_key: nil,
       raw_block: nil
     )
     |> assign_content()}
  end

  defp assign_content(socket) do
    assign(socket,
      marquee: Site.Rooms.value(@room, "marquee", default_for("marquee")),
      doces: Site.Rooms.value(@room, "doces", default_for("doces")),
      bebidas: Site.Rooms.value(@room, "bebidas", default_for("bebidas")),
      pratos: Site.Rooms.value(@room, "pratos", default_for("pratos")),
      nao_servimos: Site.Rooms.value(@room, "nao_servimos", default_for("nao_servimos")),
      proximos: Site.Rooms.value(@room, "proximos", default_for("proximos"))
    )
  end

  defp default_for("marquee") do
    "*~*~* aberto 24h pra namorada *~*~* combo cookie + cappuccino: especial da casa *~*~* cozinha vegetariana *~*~* sem berinjela jamais *~*~*"
  end

  defp default_for("doces") do
    """
    cookie americano
    chocolate branco c/ cookies-and-cream
    brigadeiro caseiro
    cappuccino doce de leite (de pozinho)
    """
    |> String.trim()
  end

  defp default_for("bebidas") do
    """
    Coca Zero
    café
    cappuccino
    """
    |> String.trim()
  end

  defp default_for("pratos") do
    """
    cachorro quente (o famoso)
    strogonoff de cogumelos
    """
    |> String.trim()
  end

  defp default_for("nao_servimos") do
    """
    berinjela
    risoto
    """
    |> String.trim()
  end

  defp default_for("proximos") do
    """
    panquequinha de domingo
    macarrão da vovó
    bolinho de chuva pra dia frio
    + ideias da chef em desenvolvimento
    """
    |> String.trim()
  end

  defp default_for(_), do: ""

  def render(assigns) do
    ~H"""
    <main class="bg-diner min-h-screen px-4 py-6 pb-20">
      <div class="max-w-3xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep border-5 border-vinho">
          <p class="font-pixel text-sunset-rose text-base tracking-wider uppercase">~ desde 03 de janeiro ~</p>
          <h1 class="wordart text-4xl sm:text-6xl mb-2">jhene's diner</h1>
          <p class="font-pixel text-vinho-soft text-lg">menu da casa</p>
          <p class="font-pixel text-vinho text-base mt-2">[ ( O ) ]  [ ( O ) ]  [ ( O ) ]</p>
        </header>

        <div class="bg-pink text-cream py-2 border-4 border-vinho shadow-cute mb-6">
          <.editable
            id="menu-marquee"
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
          <div class="border-3 border-dashed border-pink p-4">
            <h2 class="font-bubblegum text-pink text-3xl mb-3 text-center">~* doces *~</h2>
            <.editable
              id="menu-doces"
              key="doces"
              authed={@jhene_authorized}
              editing_key={@editing_key}
              raw={@raw_block}
              rows={6}
              hint="um doce por linha"
            >
              <ul class="flex flex-col gap-2 text-base">
                <li :for={item <- Site.Rooms.lines(@doces)} class="flex justify-between border-b border-dashed border-bubblegum pb-2 last:border-b-0">
                  <span class="font-bubblegum">{item}</span>
                  <span class="font-pixel text-sunset-rose">R$ &lt;3</span>
                </li>
              </ul>
            </.editable>
          </div>
        </section>

        <section class="card-y2k mb-6">
          <div class="border-3 border-dashed border-mostarda p-4">
            <h2 class="font-bubblegum text-sunset-orange text-3xl mb-3 text-center">~* bebidas *~</h2>
            <.editable
              id="menu-bebidas"
              key="bebidas"
              authed={@jhene_authorized}
              editing_key={@editing_key}
              raw={@raw_block}
              rows={5}
              hint="uma bebida por linha"
            >
              <ul class="flex flex-col gap-2 text-base">
                <li :for={item <- Site.Rooms.lines(@bebidas)} class="flex justify-between border-b border-dashed border-mostarda pb-2 last:border-b-0">
                  <span class="font-bubblegum">{item}</span>
                  <span class="font-pixel text-sunset-rose">~~~</span>
                </li>
              </ul>
            </.editable>
          </div>
        </section>

        <section class="card-y2k mb-6">
          <div class="border-3 border-dashed border-musgo p-4">
            <h2 class="font-bubblegum text-musgo text-3xl mb-3 text-center">~* pratos da chef zoey *~</h2>
            <.editable
              id="menu-pratos"
              key="pratos"
              authed={@jhene_authorized}
              editing_key={@editing_key}
              raw={@raw_block}
              rows={5}
              hint="um prato por linha"
            >
              <ul class="flex flex-col gap-2 text-base">
                <li :for={item <- Site.Rooms.lines(@pratos)} class="flex justify-between border-b border-dashed border-menta pb-2 last:border-b-0">
                  <span class="font-bubblegum">{item}</span>
                  <span class="font-pixel text-sunset-rose">[ chef ]</span>
                </li>
              </ul>
            </.editable>
            <p class="font-pixel text-vinho-soft text-base mt-3 text-center">
              servido com colher de pau e muito amor
            </p>
          </div>
        </section>

        <section class="bg-vinho border-4 border-mostarda shadow-deep p-5 mb-6">
          <h2 class="font-pixel text-mostarda text-3xl mb-3 text-center uppercase tracking-wider">
            ! não servimos !
          </h2>
          <.editable
            id="menu-nao-servimos"
            key="nao_servimos"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={4}
            hint="um item por linha (proibidos)"
          >
            <ul class="font-bubblegum text-cream text-xl text-center flex flex-col gap-2">
              <li :for={item <- Site.Rooms.lines(@nao_servimos)}>X {item} X</li>
            </ul>
          </.editable>
          <p class="font-pixel text-limao text-base text-center mt-3">
            [ se insistir, será convidada a se retirar ]
          </p>
        </section>

        <section class="card-y2k">
          <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            próximos pratos
          </h2>
          <.editable
            id="menu-proximos"
            key="proximos"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={5}
            hint="um item por linha"
          >
            <ul class="font-comic text-vinho text-base flex flex-col gap-1">
              <li :for={item <- Site.Rooms.lines(@proximos)}>- {item}</li>
            </ul>
          </.editable>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
