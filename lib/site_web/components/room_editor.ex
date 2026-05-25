defmodule SiteWeb.RoomEditor do
  @moduledoc """
  Shared bits for rooms that expose editable content blocks. Provides:

    * the `editable/1` Phoenix function component
    * a `use SiteWeb.RoomEditor, room: "quarto"` macro that installs the
      common handle_event / handle_info callbacks for editing blocks.

  Each room that uses this must implement `assign_content/1` (refresh
  socket assigns from `Site.Rooms.value/3`) and `default_for/1` (return
  the default raw value for a given key).
  """

  use Phoenix.Component

  attr :id, :string, required: true
  attr :key, :string, required: true
  attr :authed, :boolean, default: false
  attr :editing_key, :string, default: nil
  attr :raw, :string, default: nil
  attr :hint, :string, default: nil
  attr :rows, :integer, default: 6
  attr :class, :string, default: ""
  attr :button_class, :string, default: ""
  # Optional stub appended when "+ adicionar" is clicked. Used for
  # list-shaped blocks (records, lines, pairs, paragraphs) so jhene
  # gets a starter template instead of a blank textarea.
  attr :template, :string, default: nil
  attr :add_label, :string, default: "+ adicionar"
  # Alignment of the [ editar ] / [ + add ] button row. Use "center" for
  # marquees and centered headers, "start" (default) for cards.
  attr :align, :string, default: "start", values: ~w(start center end)
  slot :inner_block, required: true

  def editable(assigns) do
    ~H"""
    <div id={@id} class={"editable-block " <> @class}>
      <%= if @authed and @editing_key == @key do %>
        <form phx-submit="save_block" class="flex flex-col gap-2 my-2">
          <input type="hidden" name="key" value={@key} />
          <textarea
            name="value"
            rows={@rows}
            class="w-full p-3 border-3 border-vinho bg-cream font-comic text-base"
          >{@raw}</textarea>
          <p :if={@hint} class="font-pixel text-vinho-soft text-base">[ {@hint} ]</p>
          <div class="flex flex-wrap gap-2">
            <button
              type="submit"
              class="bg-musgo text-cream border-3 border-vinho px-3 py-1 font-pixel text-lg"
            >
              salvar
            </button>
            <button
              type="button"
              phx-click="cancel_block_edit"
              class="bg-cream text-vinho border-3 border-vinho px-3 py-1 font-pixel text-lg"
            >
              cancelar
            </button>
            <button
              type="button"
              phx-click="reset_block"
              phx-value-key={@key}
              data-confirm="resetar pro original?"
              class="bg-bubblegum text-vinho border-3 border-vinho px-3 py-1 font-pixel text-lg"
            >
              resetar
            </button>
          </div>
        </form>
      <% else %>
        {render_slot(@inner_block)}
        <div :if={@authed} class={"mt-2 flex flex-wrap gap-2 " <> align_class(@align)}>
          <button
            phx-click="edit_block"
            phx-value-key={@key}
            class={"font-pixel text-vinho bg-cream border-2 border-vinho px-2 py-0.5 text-sm shadow-cute hover-lift " <> @button_class}
          >
            [ editar ]
          </button>
          <button
            :if={@template}
            phx-click="add_template"
            phx-value-key={@key}
            phx-value-template={@template}
            class="font-pixel text-cream bg-musgo border-2 border-vinho px-2 py-0.5 text-sm shadow-cute hover-lift"
          >
            [ {@add_label} ]
          </button>
        </div>
      <% end %>
    </div>
    """
  end

  defp align_class("center"), do: "justify-center"
  defp align_class("end"), do: "justify-end"
  defp align_class(_), do: "justify-start"

  defmacro __using__(opts) do
    room = Keyword.fetch!(opts, :room)

    quote do
      alias Site.Rooms

      @room unquote(room)

      def handle_event("edit_block", %{"key" => key}, socket) do
        raw = Rooms.value(@room, key, default_for(key))
        {:noreply, assign(socket, editing_key: key, raw_block: raw)}
      end

      def handle_event("add_template", %{"key" => key, "template" => template}, socket) do
        current = Rooms.value(@room, key, default_for(key))
        separator = if String.trim(current) == "", do: "", else: "\n\n"
        raw = current <> separator <> template
        {:noreply, assign(socket, editing_key: key, raw_block: raw)}
      end

      def handle_event("cancel_block_edit", _, socket) do
        {:noreply, assign(socket, editing_key: nil, raw_block: nil)}
      end

      def handle_event("save_block", %{"key" => key, "value" => value}, socket) do
        case Rooms.upsert(@room, key, value, socket.assigns.jhene_authorized) do
          {:ok, _} ->
            {:noreply,
             socket
             |> assign(editing_key: nil, raw_block: nil)
             |> assign_content()}

          {:error, :unauthorized} ->
            {:noreply, Phoenix.LiveView.put_flash(socket, :error, "só a jhene edita")}

          {:error, %Ecto.Changeset{} = cs} ->
            msg = cs.errors |> Enum.map_join("; ", fn {f, {m, _}} -> "#{f}: #{m}" end)
            {:noreply, Phoenix.LiveView.put_flash(socket, :error, msg)}
        end
      end

      def handle_event("reset_block", %{"key" => key}, socket) do
        case Rooms.delete(@room, key, socket.assigns.jhene_authorized) do
          :ok ->
            {:noreply,
             socket
             |> assign(editing_key: nil, raw_block: nil)
             |> assign_content()}

          {:error, :unauthorized} ->
            {:noreply, Phoenix.LiveView.put_flash(socket, :error, "só a jhene edita")}
        end
      end

      def handle_info({:room_block_updated, %{room: r}}, socket) when r == @room do
        {:noreply, assign_content(socket)}
      end

      def handle_info({:room_block_deleted, %{room: r}}, socket) when r == @room do
        {:noreply, assign_content(socket)}
      end

      def handle_info(_, socket), do: {:noreply, socket}
    end
  end
end
