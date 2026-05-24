defmodule SiteWeb.SplashLive do
  use SiteWeb, :live_view

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
    {:ok, assign(socket, page_title: "jheni.pink", decos: @decos)}
  end

  def render(assigns) do
    ~H"""
    <main class="bg-splash min-h-screen relative overflow-hidden">
      <div class="bg-vinho text-mostarda border-b-4 border-mostarda py-2 marquee relative z-10">
        <span class="marquee-inner font-pixel text-lg tracking-wider">
          *~*~*~* bem-vinda ao jheni ponto pink *~*~*~* deixa um recado no livro *~*~*~* no ar desde 2026 *~*~*~* beijinhos zoey *~*~*~*
        </span>
      </div>

      <span :for={d <- @decos} class="float-deco" style={deco_style(d)}>{d.char}</span>

      <div class="flex items-center justify-center" style="min-height: calc(100vh - 3.5rem); min-height: calc(100dvh - 3.5rem);">
        <div class="text-center w-full max-w-lg relative z-10 p-6">
          <p class="font-pixel text-cream text-base mb-2 tracking-wider">*~* página pessoal da *~*</p>
          <h1 class="wordart text-6xl sm:text-7xl mb-3">jheni.pink</h1>
          <p class="font-pixel text-cream text-lg mb-8 tracking-wider">
            Jhenifer M. ~ Campos ~ desde 2026
          </p>

          <.link navigate={~p"/mapa"} class="btn-y2k btn-pulse">
            [ clica pra entrar ]
          </.link>

          <div class="font-pixel text-cream text-sm mt-8 leading-relaxed">
            melhor visto em 1024x768 :)<br />
            feito com muito amor pela <a href="https://zoedsoupe.zeetech.io">zoey</a>
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
