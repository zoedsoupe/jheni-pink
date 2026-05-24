defmodule SiteWeb.DiarioLive do
  use SiteWeb, :live_view

  alias Site.Posts
  alias Site.Posts.Post

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Posts.subscribe()

    {:ok,
     socket
     |> assign(
       page_title: "diário",
       posts: Posts.list_recent(),
       stickers: Post.stickers(),
       editing_id: nil,
       latest_id: nil
     )
     |> assign_new_form()}
  end

  @impl true
  def handle_event("validate", %{"post" => params}, socket) do
    changeset =
      %Post{}
      |> Posts.change_post(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"post" => params}, socket) do
    case Posts.create_post(params, socket.assigns.jhene_authorized) do
      {:ok, post} ->
        {:noreply,
         socket
         |> assign(latest_id: post.id)
         |> assign_new_form()}

      {:error, :unauthorized} ->
        {:noreply, put_flash(socket, :error, "só a jhene posta aqui")}

      {:error, %Ecto.Changeset{} = cs} ->
        {:noreply, assign_form(socket, cs)}
    end
  end

  def handle_event("edit", %{"id" => id}, socket) do
    if socket.assigns.jhene_authorized do
      post = Posts.get(id)

      {:noreply,
       socket
       |> assign(editing_id: String.to_integer(id))
       |> assign(edit_form: to_form(Posts.change_post(post), as: "post"))}
    else
      {:noreply, socket}
    end
  end

  def handle_event("cancel_edit", _, socket), do: {:noreply, assign(socket, editing_id: nil)}

  def handle_event("update", %{"post" => params, "post_id" => id}, socket) do
    post = Posts.get(id)

    case Posts.update_post(post, params, socket.assigns.jhene_authorized) do
      {:ok, _} -> {:noreply, assign(socket, editing_id: nil)}
      {:error, :unauthorized} -> {:noreply, put_flash(socket, :error, "só a jhene edita")}
      {:error, %Ecto.Changeset{} = cs} -> {:noreply, assign(socket, edit_form: to_form(cs, as: "post"))}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get(id)

    case Posts.delete_post(post, socket.assigns.jhene_authorized) do
      {:ok, _} -> {:noreply, socket}
      {:error, :unauthorized} -> {:noreply, put_flash(socket, :error, "só a jhene deleta")}
    end
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    posts = [post | Enum.reject(socket.assigns.posts, &(&1.id == post.id))]
    {:noreply, assign(socket, posts: posts, latest_id: post.id)}
  end

  def handle_info({:post_updated, post}, socket) do
    posts = Enum.map(socket.assigns.posts, fn p -> if p.id == post.id, do: post, else: p end)
    {:noreply, assign(socket, posts: posts)}
  end

  def handle_info({:post_deleted, post}, socket) do
    posts = Enum.reject(socket.assigns.posts, &(&1.id == post.id))
    {:noreply, assign(socket, posts: posts)}
  end

  defp assign_new_form(socket) do
    cs = Posts.change_post(%Post{sticker: "<3"})
    assign_form(socket, cs)
  end

  defp assign_form(socket, %Ecto.Changeset{} = cs) do
    assign(socket, form: to_form(cs, as: "post"))
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

  @impl true
  def render(assigns) do
    ~H"""
    <main class="bg-diario min-h-screen px-4 py-6 pb-20">
      <div class="max-w-2xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-5xl block mb-2 text-pink">&gt;&gt;&gt;</span>
          <h1 class="wordart-pink text-4xl sm:text-5xl mb-2">diário da jeni</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* o que tá passando pela minha cabeça *~*
          </p>
          <%= if @jhene_authorized do %>
            <p class="font-pixel text-musgo text-base mt-3">
              [ modo edição -- logada como {@current_jhene} ]
            </p>
          <% end %>
        </header>

        <div :if={Phoenix.Flash.get(@flash, :error)} class="card-y2k mb-4 bg-bubblegum">
          <p class="font-bubblegum text-sunset-rose text-lg">{Phoenix.Flash.get(@flash, :error)}</p>
        </div>

        <section :if={@jhene_authorized} class="card-y2k mb-6 shadow-cute">
          <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            novo post
          </h2>

          <.form for={@form} phx-change="validate" phx-submit="save" class="flex flex-col gap-3">
            <textarea
              name={@form[:content].name}
              rows="3"
              maxlength="500"
              placeholder="conta pra todo mundo..."
              class="w-full p-3 border-3 border-vinho bg-cream font-comic text-base"
            >{Phoenix.HTML.Form.normalize_value("textarea", @form[:content].value)}</textarea>
            <p :for={msg <- errors(@form[:content])} class="font-pixel text-sunset-rose text-base">{msg}</p>

            <div class="flex flex-wrap gap-2">
              <label
                :for={s <- @stickers}
                class={[
                  "px-3 py-2 border-3 border-vinho cursor-pointer font-pixel text-lg hover-lift",
                  if(@form[:sticker].value == s, do: "bg-pink text-cream", else: "bg-cream text-vinho")
                ]}
              >
                <input type="radio" name={@form[:sticker].name} value={s} checked={@form[:sticker].value == s} class="hidden" />
                {s}
              </label>
            </div>

            <button type="submit" class="btn-y2k btn-pulse">postar</button>
          </.form>
        </section>

        <section>
          <h2 class="font-bubblegum text-pink text-3xl mb-4 text-center">~* últimos posts *~</h2>

          <ul :if={@posts != []} class="flex flex-col gap-4">
            <li
              :for={p <- @posts}
              id={"post-#{p.id}"}
              class={[
                "card-y2k border-l-4 border-pink",
                if(@latest_id == p.id, do: "pop-in", else: "")
              ]}
            >
              <%= if @editing_id == p.id do %>
                <.form for={@edit_form} phx-submit="update" class="flex flex-col gap-3">
                  <input type="hidden" name="post_id" value={p.id} />
                  <textarea
                    name={@edit_form[:content].name}
                    rows="3"
                    maxlength="500"
                    class="w-full p-3 border-3 border-vinho bg-cream font-comic text-base"
                  >{Phoenix.HTML.Form.normalize_value("textarea", @edit_form[:content].value)}</textarea>

                  <div class="flex flex-wrap gap-2">
                    <label
                      :for={s <- @stickers}
                      class={[
                        "px-2 py-1 border-2 border-vinho cursor-pointer font-pixel text-base",
                        if(@edit_form[:sticker].value == s, do: "bg-pink text-cream", else: "bg-cream text-vinho")
                      ]}
                    >
                      <input type="radio" name={@edit_form[:sticker].name} value={s} checked={@edit_form[:sticker].value == s} class="hidden" />
                      {s}
                    </label>
                  </div>

                  <div class="flex gap-2">
                    <button type="submit" class="bg-musgo text-cream border-3 border-vinho px-3 py-1 font-pixel text-lg">
                      salvar
                    </button>
                    <button type="button" phx-click="cancel_edit" class="bg-cream text-vinho border-3 border-vinho px-3 py-1 font-pixel text-lg">
                      cancelar
                    </button>
                  </div>
                </.form>
              <% else %>
                <div class="flex items-start justify-between gap-3 mb-2">
                  <p class="font-comic text-vinho text-base leading-relaxed">{p.content}</p>
                  <span class="font-pixel text-vinho text-2xl shrink-0">{p.sticker}</span>
                </div>
                <div class="flex items-center justify-between mt-2 border-t border-dashed border-bubblegum pt-2">
                  <p class="font-pixel text-vinho-soft text-base">-- {format_date(p.inserted_at)}</p>
                  <div :if={@jhene_authorized} class="flex gap-2">
                    <button phx-click="edit" phx-value-id={p.id} class="font-pixel text-pink text-base underline">
                      editar
                    </button>
                    <button
                      phx-click="delete"
                      phx-value-id={p.id}
                      data-confirm="apagar esse post?"
                      class="font-pixel text-sunset-rose text-base underline"
                    >
                      apagar
                    </button>
                  </div>
                </div>
              <% end %>
            </li>
          </ul>

          <p :if={@posts == []} class="font-pixel text-vinho-soft text-center text-lg">
            ainda não postei nada por aqui. volta depois :)
          </p>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
