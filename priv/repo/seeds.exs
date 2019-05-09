# mix run priv/repo/seeds.exs

alias Api.Repo
alias Api.Accounts
alias Api.Blog.{Post, Comment}
alias Bcrypt

"""
  Repo.delete for clearing existing data and repopulating
"""
Repo.delete_all(Comment)
Repo.delete_all(Post)
Repo.delete_all(Accounts.User)

"""
  Destructure {:ok, ...} for Ecto.build_assoc/3
  Accounts.create_user for hashing password
"""

{:ok, test_user} = %{
  name: "Test User",
  email: "test@test.com",
  password: "testuser",
  admin: false
} |> Accounts.create_user

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
  List of posts |> Enum.each
  Ecto.build_assoc/3 |> Repo.insert!/1
"""
jw_posts = [
  %{
    body: "Lalalalal",
    title: "Hello World",
    featured_image: "https://s3.aws.com/featuredImage/8dklf-2kdf",
    comments: [
      %{
        comment: "Hooray!",
        name: "Joe Joe Fo Sho"
      },
      %{
        comment: "What a great Post",
        name: "Paul Schwifty"
      },
      %{
        comment: "I don't aggree. Wanna fight about it?",
        name: "Woke-a-moke"
      }
    ]
  },
  %{
    body: "Second Post",
    title: "Hello World",
    featured_image: "https://s3.aws.com/featuredImage/123ldfs",
    comments: [
      %{
        comment: "Hooray!",
        name: "Joe Joe Fo Sho"
      },
      %{
        comment: "What a great Post",
        name: "Paul Schwifty"
      },
      %{
        comment: "I don't aggree. Wanna fight about it?",
        name: "Woke-a-moke"
      }
    ]
  },
  %{
    body: "third post",
    title: "Hello World",
    featured_image: "https://s3.aws.com/featuredImage/12",
    comments: [
      %{
        comment: "Hooray!",
        name: "Joe Joe Fo Sho"
      },
      %{
        comment: "What a great Post",
        name: "Paul Schwifty"
      },
      %{
        comment: "I don't aggree. Wanna fight about it?",
        name: "Woke-a-moke"
      }
    ]
  }
] |> Enum.each(fn(post) -> 
  Ecto.build_assoc(jw, :posts, post) |> Repo.insert!
end)









