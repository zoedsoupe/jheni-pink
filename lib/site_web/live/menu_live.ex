defmodule SiteWeb.MenuLive do
  use SiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "menu da jhene")}
  end

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

        <div class="bg-pink text-cream py-2 border-4 border-vinho shadow-cute mb-6 marquee">
          <span class="marquee-inner font-bubblegum text-xl">
            *~*~* aberto 24h pra namorada *~*~* combo cookie + cappuccino: especial da casa *~*~* cozinha vegetariana *~*~* sem berinjela jamais *~*~*
          </span>
        </div>

        <section class="card-y2k mb-6">
          <div class="border-3 border-dashed border-pink p-4">
            <h2 class="font-bubblegum text-pink text-3xl mb-3 text-center">~* doces *~</h2>
            <ul class="flex flex-col gap-2 text-base">
              <li class="flex justify-between border-b border-dashed border-bubblegum pb-2">
                <span class="font-bubblegum">cookie americano</span>
                <span class="font-pixel text-sunset-rose">R$ &lt;3</span>
              </li>
              <li class="flex justify-between border-b border-dashed border-bubblegum pb-2">
                <span class="font-bubblegum">chocolate branco c/ cookies-and-cream</span>
                <span class="font-pixel text-sunset-rose">R$ &lt;3</span>
              </li>
              <li class="flex justify-between border-b border-dashed border-bubblegum pb-2">
                <span class="font-bubblegum">brigadeiro caseiro</span>
                <span class="font-pixel text-sunset-rose">R$ &lt;3</span>
              </li>
              <li class="flex justify-between">
                <span class="font-bubblegum">cappuccino doce de leite (de pozinho)</span>
                <span class="font-pixel text-sunset-rose">R$ &lt;3&lt;3</span>
              </li>
            </ul>
          </div>
        </section>

        <section class="card-y2k mb-6">
          <div class="border-3 border-dashed border-mostarda p-4">
            <h2 class="font-bubblegum text-sunset-orange text-3xl mb-3 text-center">~* bebidas *~</h2>
            <ul class="flex flex-col gap-2 text-base">
              <li class="flex justify-between border-b border-dashed border-mostarda pb-2">
                <span class="font-bubblegum">Coca Zero</span>
                <span class="font-pixel text-sunset-rose gif-bounce inline-block">( O )</span>
              </li>
              <li class="flex justify-between border-b border-dashed border-mostarda pb-2">
                <span class="font-bubblegum">café</span>
                <span class="font-pixel text-sunset-rose">~~~</span>
              </li>
              <li class="flex justify-between">
                <span class="font-bubblegum">cappuccino</span>
                <span class="font-pixel text-sunset-rose">~~~</span>
              </li>
            </ul>
          </div>
        </section>

        <section class="card-y2k mb-6">
          <div class="border-3 border-dashed border-musgo p-4">
            <h2 class="font-bubblegum text-musgo text-3xl mb-3 text-center">~* pratos da chef zoey *~</h2>
            <ul class="flex flex-col gap-2 text-base">
              <li class="flex justify-between border-b border-dashed border-menta pb-2">
                <span class="font-bubblegum">cachorro quente (o famoso)</span>
                <span class="font-pixel text-sunset-rose">[ chef ]</span>
              </li>
              <li class="flex justify-between">
                <span class="font-bubblegum">strogonoff de cogumelos</span>
                <span class="font-pixel text-sunset-rose">[ chef ]</span>
              </li>
            </ul>
            <p class="font-pixel text-vinho-soft text-base mt-3 text-center">
              servido com colher de pau e muito amor
            </p>
          </div>
        </section>

        <section class="bg-vinho border-4 border-mostarda shadow-deep p-5 mb-6">
          <h2 class="font-pixel text-mostarda text-3xl mb-3 text-center uppercase tracking-wider">
            ! não servimos !
          </h2>
          <ul class="font-bubblegum text-cream text-xl text-center flex flex-col gap-2">
            <li>X berinjela X</li>
            <li>X risoto X</li>
          </ul>
          <p class="font-pixel text-limao text-base text-center mt-3">
            [ se insistir, será convidada a se retirar ]
          </p>
        </section>

        <section class="card-y2k">
          <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            próximos pratos
          </h2>
          <ul class="font-comic text-vinho text-base flex flex-col gap-1">
            <li>- panquequinha de domingo</li>
            <li>- macarrão da vovó</li>
            <li>- bolinho de chuva pra dia frio</li>
            <li>- + ideias da chef em desenvolvimento</li>
          </ul>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
