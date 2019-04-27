# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Api.Repo.insert!(%Api.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Api.Accounts
alias Api.Blog


account_data = [
  %{
    name: "admin", 
    email: "admin@admin.com", 
    password: "administrator", 
    admin: true
  },
  %{
    name: "Jonathan Whittle", 
    email: "jonathan.m.whittle@gmail.com", 
    password: "jwhittle", 
    admin: true
  }
]

comment_data = [
  %{
    comment: "What a wonderful post!"
  }
]

Api.Repo.delete_all(Accounts.User)
Api.Repo.delete_all(Blog.Post)
Api.Repo.delete_all(Blog.Comment)

Enum.each(account_data, fn(data) ->
  Accounts.create_user(data)
end)

