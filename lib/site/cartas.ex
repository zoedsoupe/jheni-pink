defmodule Site.Cartas do
  @moduledoc """
  Static content for /cartas: zoey's poemas + missões.

  Will move to DB later when the post-auth editor ships (see memory:
  jheni-post-auth-editor). For now, hardcoded.
  """

  @poemas [
    %{
      slug: "cartografia",
      titulo: "Cartografia",
      preview: "Teus olhos são armadilha antiga, um convite que já sabe a resposta...",
      texto: """
      Teus olhos são armadilha antiga, um convite que já sabe a resposta.
      Eu caio - e caio querendo.

      Tua boca desenha intenções antes mesmo de pronunciá-las;
      eu leio, traduzo, executo.

      Esse sorriso de quem já venceu antes da batalha começar -
      confesso: me rendo fácil.

      Mas é que tuas mãos me chamam por caminhos que eu conheço,
      mapas secretos sob a pele.

      Teu rosto é paisagem mutante:
      doçura, fofura, conquista -
      e essa outra expressão,
      a que guardas pra mim,
      quando sabes que és minha
      e te entregas como quem respira.

      Não preciso te convencer de nada.
      Já és minha antes do pedido,
      minha antes do toque,
      minha no intervalo entre
      o desejo e a entrega.

      E eu te quero assim:
      rendida, devota, acesa -
      sabendo exatamente onde isso vai dar.
      """
    },
    %{
      slug: "vertigem-boa",
      titulo: "Vertigem boa",
      preview: "Teu olhar me pega no meio de qualquer frase...",
      texto: """
      Teu olhar me pega no meio de qualquer frase. Teu sorriso, aquele, o
      que já sabe que ganhou. Me dá uma vertigem boa que eu nem quero curar.

      Que jeito é esse de saber de mim antes de mim?

      Eu, que penso em espiral, que prevejo vinte cenários antes do café,
      que monto a estrutura antes de pisar; contigo eu perco o fio. E é bom.
      É assustador e é bom.

      Você me manda música quando eu nem sei que tô triste. Me pergunta
      como eu tô quando eu ainda tô fingindo que tô bem. Me olha como se
      eu não precisasse ser nada além de estar ali.

      Eu construí um pedestal tão alto que esqueci como descer. Aí você
      chegou de mansinho, sem pedir licença, e quando eu vi já tava no
      chão: e o chão contigo é mais seguro que qualquer altura.

      Quero as bobagens todas. A risada sem motivo, a briga por nada, o
      beijo no meio da frase, o silêncio que não precisa preencher.

      Quero manhã preguiçosa onde eu não resolvo nada. Tarde perdida onde
      você me mostra coisa que eu não conheço. Noite que vira madrugada e
      eu esqueço de prever o amanhã. Ah, tem que dormir né? :(

      Como pode querer tanto assim? E como pode alguém querer entrar nessa
      espiral comigo... e ficar?

      Essas flores são só um pedaço do que não cabe em palavra: te quero
      hoje, amanhã, no depois que a gente ainda vai inventar.

      tua morceguinho
      """
    },
    %{
      slug: "atos-intensos-de-um-arco",
      titulo: "atos intensos de um arco",
      preview: "Jhengibrinha, tem algo de estranho em conseguir nomear isso...",
      texto: """
      Jhengibrinha,

      Tem algo de estranho em conseguir nomear isso que a gente construiu.
      Geralmente eu erro: demonstro demais, falo de menos, ou o contrário,
      ou os dois ao mesmo tempo. Contigo parece que o excesso encontrou um
      lugar onde caber.

      Eu, que sempre carreguei, que sempre corri na frente fingindo que era
      fácil - encontro em ti o susto bom de ser alcançada. Não porque você
      corre atrás; você simplesmente aparece. Com uma pergunta no lugar
      certo, um "tô aqui" que não exige nada, um cuidado que não pesa. E
      eu, que transformo tudo em problema pra resolver sozinha, me pego
      deixando. Deixando você ficar. Deixando você ver.

      É sempre esquisito confiar assim. Eu *achei* que construí paredes tão
      bem feitas, tão funcionais, e você entra por uma porta que eu nem
      lembrava que existia. Sem pressa, sem força. Só fica. E quando eu
      surto, você não tenta consertar; você senta do lado e espera eu
      lembrar como se respira.

      O mundo lá fora continua barulhento, cheio de coisa errada, de gente
      cansativa, de expectativa que não cabe em lugar nenhum. Mas aqui
      dentro; nesse espaço ridículo que a gente inventou entre piada sem
      sentido e declaração disfarçada de bom dia: aqui parece seguro. Aqui
      eu posso ser irritadiça, confusa, triste, tesuda, boba, tudo junto,
      tudo no mesmo dia, e você fecha com foto fofinha.

      Sua volta é só um marcador, outro ciclo, um novo ciclo. O que me
      interessa é o depois; e o depois do depois. Não como plano fechado,
      mas como possibilidade. Descobrir contigo como é viajar junto,
      acordar junto, brigar por bobagem junto e resolver rindo. Continuar
      inventando esse negócio que a gente chama de namoro, intenso, mas
      que funciona.

      Você já é minha. De um jeito que não aperta, não sufoca. De um jeito
      que eu escolho todo dia, e todo dia parece fácil escolher.

      Te amo do tipo que assusta um pouco. Mas do tipo bom de susto.

      sua morceguinho
      """
    }
  ]

  @missoes [
    %{
      slug: "agente-008",
      titulo: "Missão Agente 008",
      data: "10/02/2026",
      preview: "agente 008 jhengibrinha, tenho uma missão super ultra mega secreta...",
      texto: """
      agente 008 jhengibrinha, tenho uma missão super ultra mega secreta e
      importante pra você. sua missão é ir ao endereço em anexo a partir
      das 10h, se identificar com o codinome "jhenifer", e buscar uma
      encomenda muito secreta e perigosa! apenas você tem essa capacidade!
      tome cuidado!

      como prova de missão cumprida, você deve gravar em vídeo o máximo
      que conseguir. conto com você!
      """
    }
  ]

  def poemas, do: @poemas
  def missoes, do: @missoes

  def find_poema(slug), do: Enum.find(@poemas, &(&1.slug == slug))
  def find_missao(slug), do: Enum.find(@missoes, &(&1.slug == slug))
end
