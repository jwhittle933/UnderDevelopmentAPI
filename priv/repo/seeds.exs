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

alias Api.Repo
alias Api.Accounts
alias Api.Blog.{Post, Comment}

"""
  Repo.delete for clearing existing data and repopulating
"""
Repo.delete_all(Post)
Repo.delete_all(Comment)
Repo.delete_all(Accounts.User)

"""
  Destructure {:ok, ...} for Ecto.build_assoc/3
  Accounts.create_user for hashing password
"""
{:ok, admin_cred} = %{
  name: "admin", 
  email: "admin@admin.com", 
  password: "administrator", 
  admin: true
} |> Accounts.create_user

{:ok, jw} = %{
  name: "Jonathan Whittle", 
  email: "jonathan.m.whittle@gmail.com", 
  password: "jwhittle", 
  admin: true
} |> Accounts.create_user

"""
  Lists of posts |> Enum.each
  Ecto.build_assoc/3 |> Repo.insert!/1
"""
jw_posts = [
  %{
    body: "Lalalalal",
    title: "Hello World",
    featured_image: "https://s3.aws.com/featuredImage/8dklf-2kdf",
  },
  %{
    body: "Second Post",
    title: "Hello World",
    featured_image: "https://s3.aws.com/featuredImage/123ldfs",
  },
  %{
    body: "third post",
    title: "Hello World",
    featured_image: "https://s3.aws.com/featuredImage/12",
  }
] |> Enum.each(fn(post) -> 
  Ecto.build_assoc(jw, :posts, post) |> Repo.insert!
end)








