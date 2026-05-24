defmodule SiteWeb.PsicoLive do
  use SiteWeb, :live_view
  use SiteWeb.RoomEditor, room: "psico"

  import SiteWeb.RoomEditor, only: [editable: 1]

  @prateleiras [
    %{key: "estante_fenomenologia", area: "Fenomenologia", cor: "bg-bubblegum"},
    %{key: "estante_genero", area: "Gênero & Sexualidade", cor: "bg-menta"},
    %{key: "estante_diferenca", area: "Filosofia da Diferença", cor: "bg-mostarda"}
  ]

  def mount(_params, _session, socket) do
    if connected?(socket), do: Site.Rooms.subscribe()

    {:ok,
     socket
     |> assign(
       page_title: "psico - a estante",
       prateleiras: @prateleiras,
       editing_key: nil,
       raw_block: nil
     )
     |> assign_content()}
  end

  defp assign_content(socket) do
    extra =
      Map.new(@prateleiras, fn p ->
        {String.to_atom(p.key), Site.Rooms.value(@room, p.key, default_for(p.key))}
      end)

    socket
    |> assign(
      marquee: Site.Rooms.value(@room, "marquee", default_for("marquee")),
      coloquio_title: Site.Rooms.value(@room, "coloquio_title", default_for("coloquio_title")),
      coloquio_date: Site.Rooms.value(@room, "coloquio_date", default_for("coloquio_date")),
      coloquio: Site.Rooms.value(@room, "coloquio", default_for("coloquio")),
      agora_lendo: Site.Rooms.value(@room, "agora_lendo", default_for("agora_lendo"))
    )
    |> assign(extra)
  end

  defp default_for("marquee") do
    "*~* o corpo não mente *~* o sexo não é natural *~* o gênero é performativo *~* devir mulher devir lésbica *~* fenomenologia é meu lugar feliz *~*"
  end

  defp default_for("estante_fenomenologia") do
    """
    nome: Edmund Husserl
    obra: Investigações Lógicas / Ideias

    nome: Maurice Merleau-Ponty
    obra: Fenomenologia da Percepção

    nome: Martin Heidegger
    obra: Ser e Tempo
    """
    |> String.trim()
  end

  defp default_for("estante_genero") do
    """
    nome: Judith Butler
    obra: Problemas de Gênero / Corpos que Importam

    nome: Monique Wittig
    obra: O Pensamento Hetero / O Corpo Lésbico

    nome: Simone de Beauvoir
    obra: O Segundo Sexo

    nome: Gayle Rubin
    obra: Pensando o Sexo / Tráfego de Mulheres
    """
    |> String.trim()
  end

  defp default_for("estante_diferenca") do
    """
    nome: Gilles Deleuze & Felix Guattari
    obra: Mil Platôs / Anti-Édipo
    """
    |> String.trim()
  end

  defp default_for("coloquio_title"), do: "II Colóquio de Fenomenologia Clínica"
  defp default_for("coloquio_date"), do: "21-22 de maio de 2026 -- UFF Campos"

  defp default_for("coloquio") do
    """
    dois dias de palestra, mesa redonda e gente brilhante falando de
    corpo, clínica e mundo-vivido. saí de lá com a cabeça cheia e o
    caderno mais cheio ainda. Husserl seria a primeira pessoa na
    festa.
    """
    |> String.trim()
  end

  defp default_for("agora_lendo") do
    """
    esse cantinho fica reservado pro livro do mês -- ainda em obra
    mas em breve com resenha curtinha sobre o que tá na mesa de
    cabeceira.
    """
    |> String.trim()
  end

  defp default_for(_), do: ""

  def render(assigns) do
    ~H"""
    <main class="bg-psico min-h-screen px-4 py-6 pb-20">
      <div class="max-w-4xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-5xl block mb-2 text-vinho">[ B ]</span>
          <h1 class="wordart-pink text-4xl sm:text-5xl mb-2">a estante</h1>
          <p class="font-pixel text-vinho-soft text-base">
            *~* psicologia, filosofia e gente que pensa o corpo *~*
          </p>
        </header>

        <div class="bg-sunset-rose text-cream py-2 border-4 border-vinho shadow-cute mb-6">
          <.editable
            id="psico-marquee"
            key="marquee"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={3}
          >
            <div class="marquee">
              <span class="marquee-inner font-bubblegum text-xl">{@marquee}</span>
            </div>
          </.editable>
        </div>

        <section :for={p <- @prateleiras} class="card-y2k mb-6">
          <h2 class={"font-bubblegum text-vinho text-2xl sm:text-3xl mb-4 px-3 py-2 border-3 border-vinho inline-block #{p.cor}"}>
            {p.area}
          </h2>
          <.editable
            id={"psico-#{p.key}"}
            key={p.key}
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={10}
            hint="cada autora: 'nome:' e 'obra:' em duas linhas, separadas das próximas por uma linha em branco"
          >
            <ul class="flex flex-col gap-3">
              <li :for={a <- Site.Rooms.records(Map.fetch!(assigns, String.to_atom(p.key)))} class="border-l-4 border-pink pl-3 py-1">
                <div class="font-bubblegum text-pink text-xl">{a["nome"]}</div>
                <div class="font-pixel text-vinho-soft text-base">{a["obra"]}</div>
              </li>
            </ul>
          </.editable>
        </section>

        <section class="bg-sunset-gradient border-4 border-vinho shadow-cute p-6 mb-6">
          <.editable
            id="psico-coloquio-title"
            key="coloquio_title"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={2}
            hint="título do colóquio"
          >
            <h2 class="font-bubblegum text-cream text-3xl mb-2">{@coloquio_title}</h2>
          </.editable>
          <.editable
            id="psico-coloquio-date"
            key="coloquio_date"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={2}
            hint="datas e local"
          >
            <p class="font-pixel text-cream text-lg mb-2">{@coloquio_date}</p>
          </.editable>
          <.editable
            id="psico-coloquio"
            key="coloquio"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={6}
            hint="texto do registro"
          >
            <p class="font-comic text-cream text-base leading-relaxed">{@coloquio}</p>
          </.editable>
          <p class="font-pixel text-mostarda text-base mt-3">[ registro #001 ]</p>
        </section>

        <section class="card-y2k">
          <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            agora lendo
          </h2>
          <.editable
            id="psico-agora-lendo"
            key="agora_lendo"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={4}
            hint="o que tá lendo agora"
          >
            <p class="font-comic text-vinho text-base leading-relaxed">{@agora_lendo}</p>
          </.editable>
        </section>
      </div>

      <.link navigate={~p"/mapa"} class="back-mapa">&lt;- mapa</.link>
    </main>
    """
  end
end
