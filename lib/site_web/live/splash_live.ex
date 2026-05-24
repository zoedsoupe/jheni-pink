defmodule SiteWeb.SplashLive do
  use SiteWeb, :live_view
  use SiteWeb.RoomEditor, room: "splash"

  import SiteWeb.RoomEditor, only: [editable: 1]

  alias Site.Stats

  @decos [
    %{top: "18%", left: "6%",   size: "1.8rem", char: "*"},
    %{top: "24%", right: "10%", size: "1.4rem", char: "~"},
    %{top: "34%", left: "18%",  size: "1.6rem", char: "+"},
    %{top: "42%", right: "22%", size: "1.8rem", char: "*"},
    %{top: "58%", left: "4%",   size: "1.5rem", char: "."},
    %{top: "64%", right: "5%",  size: "1.6rem", char: "*"},
    %{top: "70%", left: "8%",   size: "1.8rem", char: "+"},
    %{top: "78%", right: "12%", size: "1.6rem", char: "~"},
    %{top: "85%", left: "30%",  size: "1.5rem", char: "*"},
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
       page_title: "jeni",
       decos: @decos,
       editing_key: nil,
       raw_block: nil
     )
     |> assign_content()}
  end

  defp assign_content(socket) do
    assign(socket,
      marquee: Site.Rooms.value(@room, "marquee", default_for("marquee")),
      subtitle: Site.Rooms.value(@room, "subtitle", default_for("subtitle"))
    )
  end

  defp default_for("marquee") do
    "*~*~*~* bem-vinda ao jeni ponto pink *~*~*~* deixa um recado no livro *~*~*~* no ar desde 2026 *~*~*~* beijinhos zoey *~*~*~*"
  end

  defp default_for("subtitle"), do: "jhene ~ mineira ~ desde 2026"
  defp default_for(_), do: ""

  def render(assigns) do
    ~H"""
    <main class="bg-splash min-h-screen relative overflow-hidden">
      <div class="bg-vinho text-mostarda border-b-4 border-mostarda py-2 relative z-10">
        <.editable
          id="splash-marquee"
          key="marquee"
          authed={@jhene_authorized}
          editing_key={@editing_key}
          raw={@raw_block}
          rows={3}
          hint="texto que passa rolando no topo"
        >
          <div class="marquee">
            <span class="marquee-inner font-pixel text-lg tracking-wider">{@marquee}</span>
          </div>
        </.editable>
      </div>

      <span :for={d <- @decos} class="float-deco" style={deco_style(d)}>{d.char}</span>

      <div class="flex items-center justify-center" style="min-height: calc(100vh - 3.5rem); min-height: calc(100dvh - 3.5rem);">
        <div class="text-center w-full max-w-lg relative z-10 p-6">
          <p class="font-pixel text-cream text-base mb-2 tracking-wider">*~* página pessoal da *~*</p>
          <h1 class="wordart text-7xl sm:text-7xl mb-3">jeni</h1>

          <.editable
            id="splash-subtitle"
            key="subtitle"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={2}
            hint="subtítulo abaixo do nome"
            class="mb-8"
          >
            <p class="font-pixel text-cream text-lg tracking-wider">{@subtitle}</p>
          </.editable>

          <div class="flex flex-col gap-3 items-center mb-8 font-pixel text-2xl">
            <.link
              navigate={~p"/mapa"}
              class="bg-vinho text-mostarda border-4 border-mostarda px-5 py-2 no-underline tracking-wider hover-lift"
            >
              &gt;&gt; entra no site &lt;&lt;
            </.link>
            <.link
              navigate={~p"/livro"}
              class="bg-mostarda text-vinho border-4 border-vinho px-5 py-2 no-underline tracking-wider hover-lift"
            >
              &gt;&gt; livro de recados &lt;&lt;
            </.link>
          </div>

          <div class="font-pixel text-cream text-sm mt-8 leading-relaxed flex flex-col items-center gap-2">
            <span>melhor visto em 1024x768 :)</span>
            <a href="https://zoedsoupe.zeetech.io" target="_blank" rel="noopener" class="tape no-underline">raposinha @ zeetech</a>
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
