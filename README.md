# jheni.pink

```
   *~*~*~*~*~*~*~*~*~*
  * site pra namorada *
   *~*~*~*~*~*~*~*~*~*
            <3
```

Site pessoal estilo Y2K que escrevi pra Jhene, com seus
quartinhos editáveis, álbum de fotos, livro de visitas, diário e umas
cartinhas escondidas atrás de um magic link. Disponível em
[`jhene.zeetech.io`](https://jhene.zeetech.io) (em breve `jheni.pink`).

## o que tem dentro

Onze quartinhos navegáveis a partir do `/mapa`:

| rota        | o que é                                                |
| ----------- | ------------------------------------------------------ |
| `/`         | tela de boas-vindas (bubblegum + glitter)              |
| `/mapa`     | índice central                                         |
| `/quarto`   | bio + stats + humor do dia                             |
| `/diario`   | micro-blog da jhene                                    |
| `/cheer`    | stats da atleta + campeonatos                          |
| `/psico`    | caderno de psico em formação (clínica de rua + estudo) |
| `/menu`     | menu de comidinhas favoritas                           |
| `/cartas`   | poemas + missões (magic link)                          |
| `/lesbica`  | manifesto + ancestrais                                 |
| `/livro`    | livro de recados (público)                             |
| `/links`    | playlist + sites                                       |
| `/album`    | polaroides da gente <3                                 |

A jhene logada (`/cartas/entrar`) pode editar quase tudo: caixinhas
do mapa, textos de cada quarto, fotos do álbum, e os blocos estilo
records ganham um `[ + adicionar ]` pra ela criar quantas entradas
quiser.

## stack

```
+--------------------+-------------------------------------+
|  Elixir / OTP      | 1.19 / 28                           |
|  Phoenix LiveView  | 1.8 / 1.1 (hooks colocados)         |
|  banco             | SQLite (ecto_sqlite3, single file)  |
|  CSS               | utility-first feito à mão, sem TW   |
|  email             | Swoosh + Resend (magic link)        |
|  hospedagem        | Fly.io + Cloudflare                 |
+--------------------+-------------------------------------+
```

## rodando local

```bash
mix setup                   # deps + db + assets
PORT=4001 mix phx.server    # 4000 conflita com outros apps da zoey
```

Depois abre `http://localhost:4001`. Magic link em dev vai pro mailbox
do Swoosh em `http://localhost:4001/dev/mailbox`.

## deploy

```bash
flyctl apps create jheni-pink
flyctl volumes create site_data -r gig -s 1
flyctl secrets set \
  SECRET_KEY_BASE=$(mix phx.gen.secret) \
  RESEND_API_KEY=<resend-key>
flyctl deploy
flyctl certs add jhene.zeetech.io
```

Fotos do álbum ficam num volume montado em `/data`, então
sobrevivem entre deploys.

## estrutura

```
site/
|- assets/js/           hooks colocados + cursor trail
|- config/              dev/prod/runtime + uploads_dir
|- lib/
|  |- site/
|  |  |- albums/        fotos
|  |  |- guestbook/     livro de recados
|  |  |- posts/         diário
|  |  |- rooms/         blocos editáveis genéricos
|  |  |- stats/         contador de visitas
|  |- site_web/
|     |- components/    editor + layouts
|     |- live/          uma LiveView por quarto
|- priv/
|  |- repo/migrations/  schema
|  |- static/           assets, fontes, uploads (gitignored)
```

## regrinhas que valem ouro

- texto público em PT-BR com acentuação normal
- decoração em ASCII / emoticons (`<3`, `\o/`, `:3`, `T_T`)
- sem emoji glyph, sem Tailwind, sem ORM mágica

## feito por

```
   ,/--*--\,    feito com muito amor
  *  zoey  *    pela zozo,
   \,_*_,/      em maio de 2026
```

(:
