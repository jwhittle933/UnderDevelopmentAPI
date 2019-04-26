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

admin_user = %Api.Accounts.User{name: "admin", email: "admin@admin.com", password: "administrator", admin: true}
jw = %Api.Accounts.User{name: "Jonathan Whittle", email: "jonathan.m.whittle@gmail.com", password: "jwhittle", admin: true}

Api.Repo.insert!(admin_user)
Api.Repo.insert!(jw)
