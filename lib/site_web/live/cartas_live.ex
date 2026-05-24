defmodule SiteWeb.CartasLive do
  use SiteWeb, :live_view

  alias Site.Cartas

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       page_title: "cartas",
       poemas: Cartas.poemas(),
       missoes: Cartas.missoes(),
       tab: "poemas",
       open_slug: nil
     )}
  end

  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, tab: tab, open_slug: nil)}
  end

  def handle_event("toggle", %{"slug" => slug}, socket) do
    new = if socket.assigns.open_slug == slug, do: nil, else: slug
    {:noreply, assign(socket, open_slug: new)}
  end

  def render(assigns) do
    ~H"""
    <main class="bg-cartas min-h-screen px-4 py-6 pb-20">
      <div class="max-w-3xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-5xl block mb-2 text-sunset-rose">[ @ ]</span>
          <h1 class="wordart-pink text-4xl sm:text-5xl mb-2">cartas pra jhene</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* poemas e missões da zoeyrinha *~*
          </p>

          <%= if @jhene_authorized do %>
            <p class="font-pixel text-musgo text-base mt-3">
              [ logada como {@current_jhene} ]
              <.link href={~p"/cartas/sair"} method="delete" class="font-pixel text-sunset-rose ml-2">
                sair
              </.link>
            </p>
          <% else %>
            <p class="font-pixel text-sunset-rose text-base mt-3">
              [ conteúdo trancado --
              <.link navigate={~p"/cartas/entrar"} class="font-pixel text-pink underline">
                entrar pra ler
              </.link>
              ]
            </p>
          <% end %>
        </header>

        <div :if={Phoenix.Flash.get(@flash, :info)} class="bg-menta border-3 border-vinho p-4 mb-4 shadow-cute">
          <p class="font-bubblegum text-vinho text-lg">{Phoenix.Flash.get(@flash, :info)}</p>
        </div>

        <div :if={Phoenix.Flash.get(@flash, :error)} class="bg-bubblegum border-3 border-sunset-rose p-4 mb-4 shadow-cute">
          <p class="font-bubblegum text-sunset-rose text-lg">{Phoenix.Flash.get(@flash, :error)}</p>
        </div>

        <nav class="flex gap-2 mb-6 justify-center">
          <button
            phx-click="switch_tab"
            phx-value-tab="poemas"
            class={[
              "px-4 py-2 border-3 border-vinho font-bubblegum text-xl shadow-cute",
              if(@tab == "poemas", do: "bg-vinho text-mostarda", else: "bg-cream text-vinho")
            ]}
          >
            poemas
          </button>
          <button
            phx-click="switch_tab"
            phx-value-tab="missoes"
            class={[
              "px-4 py-2 border-3 border-vinho font-bubblegum text-xl shadow-cute",
              if(@tab == "missoes", do: "bg-vinho text-mostarda", else: "bg-cream text-vinho")
            ]}
          >
            missões
          </button>
        </nav>

        <section :if={@tab == "poemas"} class="flex flex-col gap-4">
          <article :for={p <- @poemas} class="card-y2k">
            <header class="flex flex-col gap-1 mb-3 border-b-2 border-bubblegum border-dashed pb-2">
              <h2 class="font-bubblegum text-pink text-2xl">{p.titulo}</h2>
              <p class="font-pixel text-vinho-soft text-base">~ poema ~</p>
            </header>

            <%= if @jhene_authorized do %>
              <%= if @open_slug == p.slug do %>
                <pre class="font-comic text-vinho text-base leading-relaxed whitespace-pre-wrap">{p.texto}</pre>
                <button phx-click="toggle" phx-value-slug={p.slug} class="font-pixel text-sunset-rose mt-3">
                  &lt;&lt; fechar
                </button>
              <% else %>
                <p class="font-comic text-vinho-soft text-base leading-relaxed">{p.preview}</p>
                <button phx-click="toggle" phx-value-slug={p.slug} class="font-pixel text-pink mt-3">
                  &gt;&gt; abrir poema
                </button>
              <% end %>
            <% else %>
              <p class="font-comic text-vinho-soft text-base leading-relaxed locked-blur">{p.preview}</p>
              <p class="font-pixel text-sunset-rose mt-3">
                [ trancado --
                <.link navigate={~p"/cartas/entrar"} class="font-pixel text-pink underline">
                  entra pra ler
                </.link>
                ]
              </p>
            <% end %>
          </article>
        </section>

        <section :if={@tab == "missoes"} class="flex flex-col gap-4">
          <article :for={m <- @missoes} class="card-y2k">
            <header class="flex flex-col gap-1 mb-3 border-b-2 border-bubblegum border-dashed pb-2">
              <h2 class="font-bubblegum text-pink text-2xl">{m.titulo}</h2>
              <p class="font-pixel text-vinho-soft text-base">~ missão ~ {m.data}</p>
            </header>

            <%= if @jhene_authorized do %>
              <%= if @open_slug == m.slug do %>
                <pre class="font-comic text-vinho text-base leading-relaxed whitespace-pre-wrap">{m.texto}</pre>
                <button phx-click="toggle" phx-value-slug={m.slug} class="font-pixel text-sunset-rose mt-3">
                  &lt;&lt; fechar
                </button>
              <% else %>
                <p class="font-comic text-vinho-soft text-base leading-relaxed">{m.preview}</p>
                <button phx-click="toggle" phx-value-slug={m.slug} class="font-pixel text-pink mt-3">
                  &gt;&gt; abrir missão
                </button>
              <% end %>
            <% else %>
              <p class="font-comic text-vinho-soft text-base leading-relaxed locked-blur">{m.preview}</p>
              <p class="font-pixel text-sunset-rose mt-3">
                [ trancado --
                <.link navigate={~p"/cartas/entrar"} class="font-pixel text-pink underline">
                  entra pra ler
                </.link>
                ]
              </p>
            <% end %>
          </article>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
