# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PolymorphicProductions.Repo.insert!(%PolymorphicProductions.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PolymorphicProductions.Accounts
alias PolymorphicProductions.Accounts.User
alias PolymorphicProductions.Repo

User |> Repo.delete_all()

[%{name: "Admin", email: "jchernoff@polymorphic.productions", password: "password"}]
|> Enum.each(fn attr ->
  attr
  |> Accounts.create_user()
  |> elem(1)
  |> Accounts.confirm_user()
  |> elem(1)
  |> User.admin_changeset(true)
  |> Repo.update()
end)

[%{name: "User", email: "user@polymorphic.productions", password: "password"}]
|> Enum.each(fn attr ->
  attr
  |> Accounts.create_user()
  |> elem(1)
  |> Accounts.confirm_user()
  |> elem(1)
end)
