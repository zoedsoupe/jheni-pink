defmodule SiteWeb.SplashLive do
  use SiteWeb, :live_view
  use SiteWeb.RoomEditor, room: "splash"

  import SiteWeb.RoomEditor, only: [editable: 1]

  alias Site.Stats

  @decos [
    %{top: "18%", left: "6%", size: "1.8rem", char: "*"},
    %{top: "24%", right: "10%", size: "1.4rem", char: "~"},
    %{top: "34%", left: "18%", size: "1.6rem", char: "+"},
    %{top: "42%", right: "22%", size: "1.8rem", char: "*"},
    %{top: "58%", left: "4%", size: "1.5rem", char: "."},
    %{top: "64%", right: "5%", size: "1.6rem", char: "*"},
    %{top: "70%", left: "8%", size: "1.8rem", char: "+"},
    %{top: "78%", right: "12%", size: "1.6rem", char: "~"},
    %{top: "85%", left: "30%", size: "1.5rem", char: "*"},
    %{bottom: "18%", right: "30%", size: "1.4rem", char: "o"}
  ]

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Stats.bump_visits()
      Site.Rooms.subscribe()
    end

    {:ok,
     socket
     |> assign(
       page_title: "Jhene",
       decos: @decos,
       editing_key: nil,
       raw_block: nil
     )
     |> assign_content()}
  end

  defp assign_content(socket) do
    assign(socket,
      marquee: Site.Rooms.value(@room, "marquee", default_for("marquee")),
      tagline: Site.Rooms.value(@room, "tagline", default_for("tagline")),
      subtitle: Site.Rooms.value(@room, "subtitle", default_for("subtitle")),
      footer_note: Site.Rooms.value(@room, "footer_note", default_for("footer_note"))
    )
  end

  defp default_for("marquee") do
    "*~*~*~* deixa um recado no livro *~*~*~* no ar desde 2026 *~*~*~* beijinhos da zoey!! *~*~*~*"
  end

  defp default_for("tagline"), do: "*~* página pessoal da *~*"
  defp default_for("subtitle"), do: "mineira ~ psico"
  defp default_for("footer_note"), do: "melhor visto num computador ^^"
  defp default_for(_), do: ""

  def render(assigns) do
    ~H"""
    <main class="bg-splash min-h-screen relative overflow-hidden">
      <div class="glitter"></div>

      <div class="bg-sunset-rose text-cream border-b-4 border-vinho py-2 relative z-10">
        <.editable
          id="splash-marquee"
          key="marquee"
          authed={@jhene_authorized}
          editing_key={@editing_key}
          raw={@raw_block}
          rows={3}
          align="center"
          hint="texto que passa rolando no topo"
        >
          <div class="marquee">
            <span class="marquee-inner font-pixel text-lg tracking-wider">{@marquee}</span>
          </div>
        </.editable>
      </div>

      <span :for={d <- @decos} class="float-deco" style={deco_style(d)}>{d.char}</span>

      <div
        class="flex items-center justify-center"
        style="min-height: calc(100vh - 3.5rem); min-height: calc(100dvh - 3.5rem);"
      >
        <div class="text-center w-full max-w-lg relative z-10 p-6">
          <.editable
            id="splash-tagline"
            key="tagline"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={2}
            hint="linha em cima do nome"
            class="mb-2"
            align="center"
          >
            <p class="font-pixel text-vinho text-base tracking-wider">{@tagline}</p>
          </.editable>

          <h1 class="wordart-sunset text-7xl sm:text-7xl mb-3">jhene</h1>

          <.editable
            id="splash-subtitle"
            key="subtitle"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={2}
            hint="subtítulo abaixo do nome"
            class="mb-8"
            align="center"
          >
            <p class="font-pixel text-vinho text-lg tracking-wider">{@subtitle}</p>
          </.editable>

          <div class="flex flex-col gap-3 items-center mb-8">
            <.link navigate={~p"/mapa"} class="btn-y2k">
              &gt;&gt; entra no site &lt;&lt;
            </.link>
            <.link navigate={~p"/livro"} class="btn-y2k btn-y2k-alt">
              &gt;&gt; livro de recados &lt;&lt;
            </.link>
          </div>

          <div class="font-pixel text-vinho text-sm mt-8 leading-relaxed flex flex-col items-center gap-2">
            <.editable
              id="splash-footer-note"
              key="footer_note"
              authed={@jhene_authorized}
              editing_key={@editing_key}
              raw={@raw_block}
              rows={2}
              hint="frase no rodapé"
              align="center"
            >
              <span>{@footer_note}</span>
            </.editable>
            <a
              href="https://zoedsoupe.zeetech.io"
              target="_blank"
              rel="noopener"
              class="tape no-underline"
            >
              zoeyrinha @ zeetech
            </a>
          </div>
        </div>
      </div>
    </main>
    """
  end

  defp deco_style(d) do
    [
      d[:top] && "top:#{d.top}",
      d[:bottom] && "bottom:#{d.bottom}",
      d[:left] && "left:#{d.left}",
      d[:right] && "right:#{d.right}",
      d[:size] && "font-size:#{d.size}"
    ]
    |> Enum.filter(& &1)
    |> Enum.join(";")
  end
end
