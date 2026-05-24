# Script for populating the database. Run with:
#
#     mix run priv/repo/seeds.exs

alias Site.Repo
alias Site.Guestbook.Entry

# First guestbook entry: zoey -> jhene
unless Repo.get_by(Entry, nome: "zoeyrinha") do
  %Entry{}
  |> Entry.changeset(%{
    "nome" => "zoeyrinha",
    "sticker" => "<3",
    "mensagem" => """
    primeira assinatura desse livro tem que ser minha. te amo,
    jhengibrinha. esse cantinho é teu, mas vou passar por aqui
    sempre que precisar lembrar que tem gente do teu lado.

    -- zoey, 23/05/2026
    """
  })
  |> Repo.insert!()
end
