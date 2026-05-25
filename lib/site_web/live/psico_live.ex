defmodule SiteWeb.PsicoLive do
  use SiteWeb, :live_view
  use SiteWeb.RoomEditor, room: "psico"

  import SiteWeb.RoomEditor, only: [editable: 1]

  def mount(_params, _session, socket) do
    if connected?(socket), do: Site.Rooms.subscribe()

    {:ok,
     socket
     |> assign(
       page_title: "psico em formação",
       editing_key: nil,
       raw_block: nil
     )
     |> assign_content()}
  end

  defp assign_content(socket) do
    assign(socket,
      subtitle: Site.Rooms.value(@room, "subtitle", default_for("subtitle")),
      marquee: Site.Rooms.value(@room, "marquee", default_for("marquee")),
      featured_quote:
        Site.Rooms.value(@room, "featured_quote", default_for("featured_quote")),
      featured_attribution:
        Site.Rooms.value(@room, "featured_attribution", default_for("featured_attribution")),
      clinica_de_rua:
        Site.Rooms.value(@room, "clinica_de_rua", default_for("clinica_de_rua")),
      monitoria: Site.Rooms.value(@room, "monitoria", default_for("monitoria")),
      cadernos: Site.Rooms.value(@room, "cadernos", default_for("cadernos")),
      estante: Site.Rooms.value(@room, "estante", default_for("estante")),
      registros: Site.Rooms.value(@room, "registros", default_for("registros")),
      agora_lendo: Site.Rooms.value(@room, "agora_lendo", default_for("agora_lendo"))
    )
  end

  defp default_for("subtitle"), do: "~*~ caderno de uma psico em formação ~*~"

  defp default_for("marquee") do
    "*~* clínica é não-saber *~* fenomenologia é o meu lugar feliz *~* corpo é mundo-vivido *~* monitora do Crisóstomo *~* clínica de rua em Campos *~*"
  end

  defp default_for("featured_quote") do
    "ele não ensina como se faz clínica, porque não há passo a passo. fica um semestre inteiro falando sobre o não-saber."
  end

  defp default_for("featured_attribution"),
    do: "-- sobre a aula do Crisóstomo, 08/04/2026"

  defp default_for("clinica_de_rua") do
    """
    aqui é o cantinho da clínica de rua aqui em Campos. ainda em construção -- logo escrevo direito sobre o trabalho, com quem ando aprendendo e o que tá me atravessando. (jhene: clica em [editar] pra contar do teu jeito)
    """
    |> String.trim()
  end

  defp default_for("monitoria") do
    """
    monitora do Crisóstomo desde 01/04/2026. aula de clínica psicológica sob o olhar da fenomenologia e do existencialismo -- um semestre inteiro pensando o que é estar diante do outro sem manual.
    """
    |> String.trim()
  end

  defp default_for("cadernos") do
    """
    data: 21/05/2026
    local: II Colóquio, UFF Campos
    reflexao: ...
    """
    |> String.trim()
  end

  defp default_for("estante") do
    """
    nome: Edmund Husserl
    obra: Investigações Lógicas / Ideias
    area: Fenomenologia

    nome: Maurice Merleau-Ponty
    obra: Fenomenologia da Percepção
    area: Fenomenologia

    nome: Martin Heidegger
    obra: Ser e Tempo
    area: Fenomenologia

    nome: Judith Butler
    obra: Problemas de Gênero / Corpos que Importam
    area: Gênero & Sexualidade

    nome: Monique Wittig
    obra: O Pensamento Hetero / O Corpo Lésbico
    area: Gênero & Sexualidade

    nome: Simone de Beauvoir
    obra: O Segundo Sexo
    area: Gênero & Sexualidade

    nome: Gayle Rubin
    obra: Pensando o Sexo / Tráfego de Mulheres
    area: Gênero & Sexualidade

    nome: Gilles Deleuze & Felix Guattari
    obra: Mil Platôs / Anti-Édipo
    area: Filosofia da Diferença
    """
    |> String.trim()
  end

  defp default_for("registros") do
    """
    title: II Colóquio de Fenomenologia, Clínica e Contemporaneidade
    subtitle: sofrimento e angústia na psicoterapia
    date: 21 de maio de 2026 -- 10h às 13h -- UFF Campos
    texto: organizei como monitora do Crisóstomo, junto com a galera da monitoria de fenomenologia. uma manhã inteira de palestra, mesa redonda e gente brilhante falando de corpo, clínica e mundo-vivido.
    """
    |> String.trim()
  end

  defp default_for("agora_lendo") do
    """
    esse cantinho fica reservado pro livro do mês -- ainda em obra mas em breve com resenha curtinha sobre o que tá na mesa de cabeceira.
    """
    |> String.trim()
  end

  defp default_for(_), do: ""

  defp registro_num(idx) do
    (idx + 1) |> Integer.to_string() |> String.pad_leading(3, "0")
  end

  defp area_color("Fenomenologia"), do: "bg-bubblegum"
  defp area_color("Gênero & Sexualidade"), do: "bg-menta"
  defp area_color("Filosofia da Diferença"), do: "bg-mostarda"
  defp area_color(_), do: "bg-cream"

  def render(assigns) do
    ~H"""
    <main class="bg-psico min-h-screen px-4 py-6 pb-20">
      <div class="max-w-4xl mx-auto">
        <header class="card-y2k text-center mb-6 shadow-deep">
          <span class="font-pixel text-5xl block mb-2 text-vinho">[ B ]</span>
          <h1 class="wordart-pink text-4xl sm:text-5xl mb-2">psico em formação</h1>
          <.editable
            id="psico-subtitle"
            key="subtitle"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={2}
            hint="subtítulo do caderno"
            align="center"
          >
            <p class="font-pixel text-vinho-soft text-base">{@subtitle}</p>
          </.editable>
        </header>

        <div class="bg-sunset-rose text-cream py-2 border-4 border-vinho shadow-cute mb-6">
          <.editable
            id="psico-marquee"
            key="marquee"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={3}
            align="center"
          >
            <div class="marquee">
              <span class="marquee-inner font-bubblegum text-xl">{@marquee}</span>
            </div>
          </.editable>
        </div>

        <section class="bg-cream border-4 border-vinho shadow-deep p-6 mb-6 relative">
          <span class="font-pixel text-pink text-base block mb-2">[ frase do semestre ]</span>
          <.editable
            id="psico-featured-quote"
            key="featured_quote"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={4}
            hint="citação destacada (pode ser do Crisóstomo, de aula, de livro...)"
          >
            <blockquote class="font-comic text-vinho text-xl italic leading-relaxed">
              "{@featured_quote}"
            </blockquote>
          </.editable>
          <.editable
            id="psico-featured-attribution"
            key="featured_attribution"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={2}
            hint="autoria / contexto da citação"
          >
            <p class="font-pixel text-vinho-soft text-base mt-3 text-right">
              {@featured_attribution}
            </p>
          </.editable>
        </section>

        <section class="card-y2k mb-6 border-l-8 border-sunset-rose">
          <h2 class="font-bubblegum text-sunset-rose text-2xl sm:text-3xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            clínica de rua
          </h2>
          <.editable
            id="psico-clinica-de-rua"
            key="clinica_de_rua"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={8}
            hint="o trabalho na clínica de rua aqui em Campos -- parágrafos separados por linha em branco"
          >
            <div class="font-comic text-vinho text-base leading-relaxed flex flex-col gap-3">
              <p :for={para <- Site.Rooms.paragraphs(@clinica_de_rua)}>{para}</p>
            </div>
          </.editable>
        </section>

        <section class="card-y2k mb-6 border-l-8 border-mostarda">
          <h2 class="font-bubblegum text-vinho text-2xl sm:text-3xl mb-3 border-b-2 border-mostarda border-dashed pb-2">
            monitoria
          </h2>
          <.editable
            id="psico-monitoria"
            key="monitoria"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={6}
            hint="o que tô fazendo na monitoria -- parágrafos separados por linha em branco"
          >
            <div class="font-comic text-vinho text-base leading-relaxed flex flex-col gap-3">
              <p :for={para <- Site.Rooms.paragraphs(@monitoria)}>{para}</p>
            </div>
          </.editable>
        </section>

        <section class="card-y2k mb-6 border-l-8 border-musgo">
          <h2 class="font-bubblegum text-musgo text-2xl sm:text-3xl mb-3 border-b-2 border-menta border-dashed pb-2">
            cadernos de campo
          </h2>
          <ul :if={Site.Rooms.records(@cadernos) != []} class="flex flex-col gap-4 mb-3">
            <li
              :for={c <- Site.Rooms.records(@cadernos)}
              class="px-4 py-3 border-l-4 border-musgo bg-menta"
            >
              <p
                :if={c["data"] || c["local"]}
                class="font-pixel text-vinho text-base mb-1"
              >
                <span :if={c["data"]}>{c["data"]}</span>
                <span :if={c["data"] && c["local"]}> -- </span>
                <span :if={c["local"]}>{c["local"]}</span>
              </p>
              <p :if={c["reflexao"]} class="font-comic text-vinho text-base leading-relaxed">
                {c["reflexao"]}
              </p>
            </li>
          </ul>
          <p
            :if={Site.Rooms.records(@cadernos) == []}
            class="font-pixel text-vinho-soft text-base mb-3"
          >
            -- caderno em branco --
          </p>
          <.editable
            id="psico-cadernos"
            key="cadernos"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={16}
            hint="cada caderno: 'data:', 'local:', 'reflexao:' separados por linha em branco. reflexão sem quebras de linha."
            template={"data: \nlocal: \nreflexao: "}
            add_label="+ nova entrada"
          >
            <p class="font-pixel text-vinho-soft text-base">
              [ {length(Site.Rooms.records(@cadernos))} entradas -- clica em editar ou + ]
            </p>
          </.editable>
        </section>

        <section
          :for={{r, idx} <- Enum.with_index(Site.Rooms.records(@registros))}
          class="card-y2k bg-bubblegum mb-6"
        >
          <p class="font-pixel text-pink text-base mb-2">
            [ registro #{registro_num(idx)} ]
          </p>
          <h2 :if={r["title"]} class="font-bubblegum text-vinho text-2xl sm:text-3xl leading-tight">
            {r["title"]}
          </h2>
          <p :if={r["subtitle"]} class="font-comic text-vinho-soft text-lg italic mb-3">
            {r["subtitle"]}
          </p>
          <p
            :if={r["date"]}
            class="font-pixel text-vinho text-base mb-3 px-2 py-1 inline-block border-2 border-vinho bg-cream"
          >
            {r["date"]}
          </p>
          <p :if={r["texto"]} class="font-comic text-vinho text-base leading-relaxed">
            {r["texto"]}
          </p>
        </section>

        <section :if={@jhene_authorized} class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-2xl mb-3 border-b-2 border-bubblegum border-dashed pb-2">
            registros (editar)
          </h2>
          <.editable
            id="psico-registros"
            key="registros"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={20}
            hint="cada registro: 'title:', 'subtitle:', 'date:', 'texto:' separados por linha em branco. texto sem quebras de linha."
            template={"title: \nsubtitle: \ndate: \ntexto: "}
            add_label="+ novo registro"
          >
            <p class="font-pixel text-vinho-soft text-base">
              [ {length(Site.Rooms.records(@registros))} registros publicados ]
            </p>
          </.editable>
        </section>

        <section class="card-y2k mb-6">
          <h2 class="font-bubblegum text-pink text-2xl sm:text-3xl mb-4 border-b-2 border-bubblegum border-dashed pb-2">
            estante teórica
          </h2>
          <ul class="flex flex-col gap-3 mb-3">
            <li
              :for={a <- Site.Rooms.records(@estante)}
              class="border-l-4 border-pink pl-3 py-1"
            >
              <div class="font-bubblegum text-pink text-xl">{a["nome"]}</div>
              <div class="font-pixel text-vinho-soft text-base">{a["obra"]}</div>
              <span
                :if={a["area"]}
                class={"font-pixel text-vinho text-sm inline-block px-2 py-0.5 mt-1 border-2 border-vinho #{area_color(a["area"])}"}
              >
                {a["area"]}
              </span>
            </li>
          </ul>
          <.editable
            id="psico-estante"
            key="estante"
            authed={@jhene_authorized}
            editing_key={@editing_key}
            raw={@raw_block}
            rows={20}
            hint="cada autora: 'nome:', 'obra:', 'area:' separados por linha em branco. area = Fenomenologia / Gênero & Sexualidade / Filosofia da Diferença (ou outra)."
            template={"nome: \nobra: \narea: "}
            add_label="+ nova autora"
          >
            <p class="font-pixel text-vinho-soft text-base">
              [ {length(Site.Rooms.records(@estante))} autoras na estante ]
            </p>
          </.editable>
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
