defmodule SiteWeb.LivroLive do
  use SiteWeb, :live_view

  alias Site.Guestbook
  alias Site.Guestbook.Entry
  alias SiteWeb.Presence

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Guestbook.subscribe()
      Presence.subscribe()

      visitor_id =
        socket.id <> "-" <> Integer.to_string(System.unique_integer([:positive]))

      Presence.track_visitor(self(), visitor_id, %{})
    end

    ip = get_ip(socket)
    {a, b} = gen_captcha()

    {:ok,
     socket
     |> assign(
       page_title: "livro de visitas",
       entries: Guestbook.list_recent(),
       stickers: Entry.stickers(),
       online: Presence.visitor_count(),
       captcha_a: a,
       captcha_b: b,
       captcha_error: nil,
       ip: ip,
       new_entry_id: nil
     )
     |> assign_form(Guestbook.change_entry(%Entry{sticker: "<3"}))}
  end

  @impl true
  def handle_event("validate", %{"entry" => params}, socket) do
    changeset =
      %Entry{}
      |> Guestbook.change_entry(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"entry" => params, "captcha" => captcha}, socket) do
    expected = socket.assigns.captcha_a + socket.assigns.captcha_b

    case Integer.parse(captcha || "") do
      {^expected, _} -> do_save(socket, params)
      _ -> {:noreply, assign(socket, captcha_error: "captcha errado, tenta de novo")}
    end
  end

  defp do_save(socket, params) do
    case Guestbook.create_entry(params, socket.assigns.ip) do
      {:ok, entry} ->
        {a, b} = gen_captcha()

        {:noreply,
         socket
         |> assign(
           captcha_a: a,
           captcha_b: b,
           captcha_error: nil,
           new_entry_id: entry.id
         )
         |> assign_form(Guestbook.change_entry(%Entry{sticker: "<3"}))}

      {:error, :rate_limited} ->
        {:noreply,
         assign(socket, captcha_error: "calma! espera uns segundos antes de mandar de novo.")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  @impl true
  def handle_info({:new_entry, entry}, socket) do
    entries =
      [entry | socket.assigns.entries]
      |> Enum.uniq_by(& &1.id)
      |> Enum.take(50)

    {:noreply, assign(socket, entries: entries, new_entry_id: entry.id)}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, online: Presence.visitor_count())}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, form: to_form(changeset, as: "entry"))
  end

  defp gen_captcha, do: {Enum.random(1..9), Enum.random(1..9)}

  defp get_ip(socket) do
    case Phoenix.LiveView.get_connect_info(socket, :peer_data) do
      %{address: ip} -> ip |> :inet.ntoa() |> to_string()
      _ -> nil
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <main class="bg-livro min-h-screen px-4 py-6 pb-20">
      <div class="max-w-3xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-5xl block mb-2 text-vinho">[ i ]</span>
          <h1 class="wordart-pink text-4xl sm:text-5xl mb-2">livro de visitas</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* deixe seu recado pra jhene *~*
          </p>
          <p class="font-pixel text-sunset-rose text-base mt-3">
            online agora: {@online} {if @online == 1, do: "pessoa", else: "pessoas"}
          </p>
        </header>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-2xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">
            assine o livro
          </h2>

          <.form
            for={@form}
            phx-change="validate"
            phx-submit="save"
            class="flex flex-col gap-4"
          >
            <div>
              <label class="font-bubblegum text-vinho text-base block mb-1">seu nome</label>
              <input
                type="text"
                name={@form[:nome].name}
                value={Phoenix.HTML.Form.normalize_value("text", @form[:nome].value)}
                placeholder="quem tá aqui?"
                maxlength="40"
                class="w-full p-3 border-3 border-vinho bg-cream font-comic text-base"
              />
              <p :for={msg <- errors(@form[:nome])} class="font-pixel text-sunset-rose text-base mt-1">{msg}</p>
            </div>

            <div>
              <label class="font-bubblegum text-vinho text-base block mb-1">sua mensagem</label>
              <textarea
                name={@form[:mensagem].name}
                rows="4"
                maxlength="500"
                placeholder="oi jhene! seu site é..."
                class="w-full p-3 border-3 border-vinho bg-cream font-comic text-base"
              >{Phoenix.HTML.Form.normalize_value("textarea", @form[:mensagem].value)}</textarea>
              <p :for={msg <- errors(@form[:mensagem])} class="font-pixel text-sunset-rose text-base mt-1">{msg}</p>
            </div>

            <div>
              <span class="font-bubblegum text-vinho text-base block mb-2">escolhe um sticker</span>
              <div class="flex flex-wrap gap-2">
                <label
                  :for={s <- @stickers}
                  class={[
                    "px-3 py-2 border-3 border-vinho cursor-pointer font-pixel text-lg hover-lift",
                    if(@form[:sticker].value == s, do: "bg-pink text-cream", else: "bg-cream text-vinho")
                  ]}
                >
                  <input
                    type="radio"
                    name={@form[:sticker].name}
                    value={s}
                    checked={@form[:sticker].value == s}
                    class="hidden"
                  />
                  {s}
                </label>
              </div>
              <p :for={msg <- errors(@form[:sticker])} class="font-pixel text-sunset-rose text-base mt-1">{msg}</p>
            </div>

            <div class="bg-mostarda border-3 border-dashed border-vinho p-3">
              <label class="font-bubblegum text-vinho text-base block mb-1">
                pra provar que você não é robô:
              </label>
              <div class="flex items-center gap-2 font-pixel text-vinho text-2xl">
                <span>{@captcha_a} + {@captcha_b} =</span>
                <input
                  type="number"
                  name="captcha"
                  required
                  class="w-20 p-2 border-3 border-vinho bg-cream font-pixel text-xl text-center"
                />
              </div>
              <p :if={@captcha_error} class="font-pixel text-sunset-rose text-base mt-1">
                {@captcha_error}
              </p>
            </div>

            <button type="submit" class="btn-y2k btn-pulse">assinar o livro</button>
          </.form>
        </section>

        <section>
          <h2 class="font-bubblegum text-pink text-3xl mb-4 text-center">~* o que já deixaram *~</h2>

          <ul :if={@entries != []} class="flex flex-col gap-4">
            <li
              :for={e <- @entries}
              id={"entry-#{e.id}"}
              class={[
                "card-y2k border-l-4 border-sunset-rose",
                if(@new_entry_id == e.id, do: "pop-in", else: "")
              ]}
            >
              <div class="flex items-start justify-between gap-3 mb-2">
                <div class="font-bubblegum text-pink text-xl">{e.nome}</div>
                <div class="font-pixel text-vinho text-2xl">{e.sticker}</div>
              </div>
              <p class="font-comic text-vinho text-base leading-relaxed">{e.mensagem}</p>
              <p class="font-pixel text-vinho-soft text-base mt-2">
                -- {format_date(e.inserted_at)}
              </p>
            </li>
          </ul>

          <p :if={@entries == []} class="font-pixel text-vinho-soft text-center text-lg">
            ainda ninguém assinou. seja a/o primeira/o!
          </p>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end

  defp errors(field) do
    Enum.map(field.errors, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {k, v}, acc ->
        String.replace(acc, "%{#{k}}", to_string(v))
      end)
    end)
  end

  defp format_date(%DateTime{} = dt) do
    "#{pad(dt.day)}/#{pad(dt.month)}/#{dt.year} #{pad(dt.hour)}:#{pad(dt.minute)}"
  end

  defp pad(n) when n < 10, do: "0#{n}"
  defp pad(n), do: "#{n}"
end
