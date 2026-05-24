defmodule SiteWeb.AuthHTML do
  use SiteWeb, :html

  def new(assigns) do
    ~H"""
    <main class="bg-cartas min-h-screen px-4 py-6 pb-20">
      <div class="max-w-md mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-5xl block mb-2 text-sunset-rose">[ @ ]</span>
          <h1 class="wordart-pink text-4xl sm:text-5xl mb-2">entrar nas cartas</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* só pra jhene *~*
          </p>
        </header>

        <%= if @sent do %>
          <section class="card-y2k text-center">
            <p class="font-pixel text-vinho text-4xl mb-3">:)</p>
            <p class="font-bubblegum text-pink text-2xl mb-3">conferi a caixa de entrada</p>
            <p class="font-comic text-vinho text-base leading-relaxed mb-4">
              se o email estiver na lista, voce vai receber um link em alguns
              segundos. o link vale por 15 minutos.
            </p>
            <p class="font-pixel text-vinho-soft text-base">[ olha o spam também ]</p>
            <div class="mt-6">
              <.link navigate={~p"/cartas"} class="btn-y2k">&lt;- voltar</.link>
            </div>
          </section>
        <% else %>
          <section class="card-y2k">
            <p class="font-comic text-vinho text-base mb-4 leading-relaxed">
              digita seu email. se for o e-mail certo, mando um link mágico
              pra você entrar.
            </p>

            <form action={~p"/cartas/entrar"} method="post" class="flex flex-col gap-3">
              <input type="hidden" name="_csrf_token" value={get_csrf_token()} />
              <label class="font-bubblegum text-vinho text-lg" for="email">seu email</label>
              <input
                type="email"
                name="email"
                id="email"
                required
                autofocus
                placeholder="jhenifermendesj@gmail.com"
                class="w-full p-3 border-3 border-vinho bg-cream font-comic text-base"
              />
              <button type="submit" class="btn-y2k btn-pulse mt-2">
                me manda o link
              </button>
            </form>

            <div class="text-center mt-6">
              <.link navigate={~p"/cartas"} class="font-pixel text-sunset-rose">
                &lt;- voltar pras cartas
              </.link>
            </div>
          </section>
        <% end %>
      </div>
    </main>
    """
  end
end
