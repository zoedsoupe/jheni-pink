defmodule SiteWeb.AlbumLive do
  use SiteWeb, :live_view

  alias Site.Albums
  alias Site.Albums.Photo

  @max_size 5_000_000
  @accept ~w(.jpg .jpeg .png .webp)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Albums.subscribe()

    {:ok,
     socket
     |> assign(
       page_title: "album",
       photos: Albums.list_photos(),
       editing_id: nil,
       upload_caption: "",
       latest_id: nil
     )
     |> allow_upload(:photo,
       accept: @accept,
       max_entries: 1,
       max_file_size: @max_size
     )}
  end

  @impl true
  def handle_event("validate_upload", %{"caption" => caption}, socket) do
    {:noreply, assign(socket, upload_caption: caption)}
  end

  def handle_event("save_upload", %{"caption" => caption}, socket) do
    if socket.assigns.jhene_authorized do
      consumed =
        consume_uploaded_entries(socket, :photo, fn %{path: src}, entry ->
          Albums.ensure_photos_dir!()
          ext = entry.client_name |> Path.extname() |> String.downcase()
          filename = "#{Ecto.UUID.generate()}#{ext}"
          dest = Albums.file_path(filename)
          File.cp!(src, dest)

          case Albums.create_photo(
                 %{"filename" => filename, "caption" => caption},
                 true
               ) do
            {:ok, photo} -> {:ok, photo}
            {:error, %Ecto.Changeset{}} = err ->
              # rollback file on DB failure
              File.rm(dest)
              err
          end
        end)

      case consumed do
        [%Photo{} = photo | _] ->
          {:noreply,
           socket
           |> assign(latest_id: photo.id, upload_caption: "")
           |> put_flash(:info, "foto adicionada :3")}

        [] ->
          {:noreply, put_flash(socket, :error, "escolhe uma foto antes de salvar")}
      end
    else
      {:noreply, put_flash(socket, :error, "só a jhene posta fotos")}
    end
  end

  def handle_event("cancel_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  def handle_event("edit_caption", %{"id" => id}, socket) do
    if socket.assigns.jhene_authorized do
      {:noreply, assign(socket, editing_id: String.to_integer(id))}
    else
      {:noreply, socket}
    end
  end

  def handle_event("cancel_caption", _, socket) do
    {:noreply, assign(socket, editing_id: nil)}
  end

  def handle_event("save_caption", %{"photo_id" => id, "caption" => caption}, socket) do
    photo = Albums.get(id)

    case Albums.update_photo(photo, %{"caption" => caption}, socket.assigns.jhene_authorized) do
      {:ok, _} -> {:noreply, assign(socket, editing_id: nil)}
      {:error, :unauthorized} -> {:noreply, put_flash(socket, :error, "só a jhene edita")}
      {:error, %Ecto.Changeset{}} -> {:noreply, put_flash(socket, :error, "legenda muito longa")}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    photo = Albums.get(id)

    case Albums.delete_photo(photo, socket.assigns.jhene_authorized) do
      {:ok, _} -> {:noreply, socket}
      {:error, :unauthorized} -> {:noreply, put_flash(socket, :error, "só a jhene deleta")}
    end
  end

  def handle_event("move_up", %{"id" => id}, socket) do
    id |> Albums.get() |> Albums.move(:up, socket.assigns.jhene_authorized)
    {:noreply, socket}
  end

  def handle_event("move_down", %{"id" => id}, socket) do
    id |> Albums.get() |> Albums.move(:down, socket.assigns.jhene_authorized)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:photo_created, photo}, socket) do
    photos = Albums.list_photos()
    {:noreply, assign(socket, photos: photos, latest_id: photo.id)}
  end

  def handle_info({:photo_updated, _photo}, socket) do
    {:noreply, assign(socket, photos: Albums.list_photos())}
  end

  def handle_info({:photo_deleted, _photo}, socket) do
    {:noreply, assign(socket, photos: Albums.list_photos())}
  end

  def handle_info({:photo_reordered, _photo}, socket) do
    {:noreply, assign(socket, photos: Albums.list_photos())}
  end

  defp error_msg(:too_large), do: "imagem maior que 5MB"
  defp error_msg(:too_many_files), do: "uma foto por vez"
  defp error_msg(:not_accepted), do: "só jpg, png ou webp"
  defp error_msg(other), do: to_string(other)

  @impl true
  def render(assigns) do
    ~H"""
    <main class="bg-album min-h-screen px-4 py-6 pb-20">
      <div class="max-w-5xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-5xl block mb-2 text-pink">( o o )</span>
          <h1 class="wordart-pink text-4xl sm:text-5xl mb-2">album</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* retratos da gente, da minha gente *~*
          </p>
          <p :if={@jhene_authorized} class="font-pixel text-musgo text-base mt-3">
            [ modo edição -- logada como {@current_jhene} ]
          </p>
        </header>

        <div :if={Phoenix.Flash.get(@flash, :error)} class="card-y2k mb-4 bg-bubblegum">
          <p class="font-bubblegum text-sunset-rose text-lg">
            {Phoenix.Flash.get(@flash, :error)}
          </p>
        </div>
        <div :if={Phoenix.Flash.get(@flash, :info)} class="card-y2k mb-4 bg-menta">
          <p class="font-bubblegum text-musgo text-lg">{Phoenix.Flash.get(@flash, :info)}</p>
        </div>

        <section :if={@jhene_authorized} class="card-y2k mb-6 shadow-cute">
          <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            postar nova foto
          </h2>

          <form
            phx-change="validate_upload"
            phx-submit="save_upload"
            class="flex flex-col gap-3"
          >
            <label class="upload-drop block cursor-pointer" phx-drop-target={@uploads.photo.ref}>
              <.live_file_input upload={@uploads.photo} class="hidden" />
              <span class="block text-lg">[ arrasta uma foto aqui ou clica pra escolher ]</span>
              <span class="block text-base text-vinho-soft mt-1">
                jpg, png ou webp -- até 5MB
              </span>
            </label>

            <div :for={entry <- @uploads.photo.entries} class="border-3 border-vinho bg-cream p-3 flex flex-col gap-2">
              <div class="flex items-center justify-between gap-3">
                <span class="font-pixel text-vinho text-base">{entry.client_name}</span>
                <button
                  type="button"
                  phx-click="cancel_upload"
                  phx-value-ref={entry.ref}
                  class="font-pixel text-sunset-rose text-base underline"
                >
                  cancelar
                </button>
              </div>

              <.live_img_preview entry={entry} class="upload-preview" />

              <div class="font-pixel text-base text-vinho">
                <%= for err <- upload_errors(@uploads.photo, entry) do %>
                  <p class="text-sunset-rose">! {error_msg(err)}</p>
                <% end %>
                <p :if={entry.progress > 0 and entry.progress < 100}>
                  carregando: {entry.progress}%
                </p>
              </div>
            </div>

            <%= for err <- upload_errors(@uploads.photo) do %>
              <p class="font-pixel text-sunset-rose text-base">! {error_msg(err)}</p>
            <% end %>

            <input
              type="text"
              name="caption"
              value={@upload_caption}
              maxlength="200"
              placeholder="legenda (opcional)"
              class="w-full p-3 border-3 border-vinho bg-cream font-comic text-base"
            />

            <button
              type="submit"
              class="btn-y2k"
              disabled={@uploads.photo.entries == []}
            >
              postar foto
            </button>
          </form>
        </section>

        <p :if={@photos == []} class="font-pixel text-vinho-soft text-center text-lg mt-10">
          ainda não tem foto por aqui. volta depois &lt;3
        </p>

        <ul class="grid grid-1 sm:grid-2 lg:grid-3 gap-6 mt-4">
          <li
            :for={p <- @photos}
            id={"photo-#{p.id}"}
            class={[
              "polaroid",
              if(@latest_id == p.id, do: "pop-in", else: "")
            ]}
          >
            <img src={Albums.url(p)} alt={p.caption || "foto da jhene"} loading="lazy" />

            <%= if @editing_id == p.id do %>
              <form
                phx-submit="save_caption"
                class="flex flex-col gap-2 mt-2"
              >
                <input type="hidden" name="photo_id" value={p.id} />
                <input
                  type="text"
                  name="caption"
                  value={p.caption || ""}
                  maxlength="200"
                  class="w-full p-2 border-2 border-vinho bg-cream font-comic text-sm"
                  autofocus
                />
                <div class="flex gap-2 justify-center">
                  <button
                    type="submit"
                    class="bg-musgo text-cream border-2 border-vinho px-2 py-1 font-pixel text-sm"
                  >
                    salvar
                  </button>
                  <button
                    type="button"
                    phx-click="cancel_caption"
                    class="bg-cream text-vinho border-2 border-vinho px-2 py-1 font-pixel text-sm"
                  >
                    cancelar
                  </button>
                </div>
              </form>
            <% else %>
              <p class="polaroid-caption">{p.caption || "* sem legenda *"}</p>
            <% end %>

            <div :if={@editing_id != p.id} class="polaroid-controls">
              <button
                type="button"
                phx-click={JS.show(to: "#lightbox-#{p.id}", display: "flex")}
                class="font-pixel text-cream bg-sunset-rose border-2 border-vinho px-2 py-0.5 text-sm"
              >
                [ ver ]
              </button>
              <%= if @jhene_authorized do %>
                <button
                  phx-click="edit_caption"
                  phx-value-id={p.id}
                  class="font-pixel text-vinho bg-cream border-2 border-vinho px-2 py-0.5 text-sm"
                >
                  [ legenda ]
                </button>
                <button
                  phx-click="move_up"
                  phx-value-id={p.id}
                  class="font-pixel text-vinho bg-cream border-2 border-vinho px-2 py-0.5 text-sm"
                >
                  &lt;-
                </button>
                <button
                  phx-click="move_down"
                  phx-value-id={p.id}
                  class="font-pixel text-vinho bg-cream border-2 border-vinho px-2 py-0.5 text-sm"
                >
                  -&gt;
                </button>
                <button
                  phx-click="delete"
                  phx-value-id={p.id}
                  data-confirm="apagar essa foto?"
                  class="font-pixel text-cream bg-sunset-rose border-2 border-vinho px-2 py-0.5 text-sm"
                >
                  X
                </button>
              <% end %>
            </div>

            <div
              id={"lightbox-#{p.id}"}
              class="lightbox hidden"
              phx-click={JS.hide(to: "#lightbox-#{p.id}")}
            >
              <img
                src={Albums.url(p)}
                alt={p.caption || "foto"}
                class="lightbox-img"
                onclick="event.stopPropagation()"
              />
              <p
                :if={p.caption && p.caption != ""}
                class="lightbox-caption"
                onclick="event.stopPropagation()"
              >
                {p.caption}
              </p>
              <button
                type="button"
                class="lightbox-close"
                phx-click={JS.hide(to: "#lightbox-#{p.id}")}
              >
                X
              </button>
            </div>
          </li>
        </ul>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
