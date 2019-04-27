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
admin_cred = %{
  name: "admin", 
  email: "admin@admin.com", 
  password_hash: Bcrypt.add_hash("administrator")[:password_hash], 
  admin: true,
} |> Repo.insert!

jw = %{
  name: "Jonathan Whittle", 
  email: "jonathan.m.whittle@gmail.com", 
  password_hash: Bcrypt.add_hash("jwhittle")[:password_hash], 
  admin: true,
  posts: [
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
  ]
} |> Repo.insert!

"""
  Lists of posts |> Enum.each
  Ecto.build_assoc/3 |> Repo.insert!/1
"""
# jw_posts = [
#   %{
#     body: "Lalalalal",
#     title: "Hello World",
#     featured_image: "https://s3.aws.com/featuredImage/8dklf-2kdf",
#     comments: [
#       %{
#         comment: "Hooray!",
#         name: "Joe Joe Fo Sho"
#       },
#       %{
#         comment: "What a great Post",
#         name: "Paul Schwifty"
#       },
#       %{
#         comment: "I don't aggree. Wanna fight about it?",
#         name: "Woke-a-moke"
#       }
#     ]
#   },
#   %{
#     body: "Second Post",
#     title: "Hello World",
#     featured_image: "https://s3.aws.com/featuredImage/123ldfs",
#     comments: [
#       %{
#         comment: "Hooray!",
#         name: "Joe Joe Fo Sho"
#       },
#       %{
#         comment: "What a great Post",
#         name: "Paul Schwifty"
#       },
#       %{
#         comment: "I don't aggree. Wanna fight about it?",
#         name: "Woke-a-moke"
#       }
#     ]
#   },
#   %{
#     body: "third post",
#     title: "Hello World",
#     featured_image: "https://s3.aws.com/featuredImage/12",
#     comments: [
#       %{
#         comment: "Hooray!",
#         name: "Joe Joe Fo Sho"
#       },
#       %{
#         comment: "What a great Post",
#         name: "Paul Schwifty"
#       },
#       %{
#         comment: "I don't aggree. Wanna fight about it?",
#         name: "Woke-a-moke"
#       }
#     ]
#   }
# ] |> Enum.each(fn(post) -> 
#   Ecto.build_assoc(jw, :posts, post) |> Repo.insert!
# end)

# comments = [
#   %{
#     comment: "Hooray!",
#     name: "Joe Joe Fo Sho"
#   },
#   %{
#     comment: "What a great Post",
#     name: "Paul Schwifty"
#   },
#   %{
#     comment: "I don't aggree. Wanna fight about it?",
#     name: "Woke-a-moke"
#   }
# ]

# {:ok, posts} = Repo.all(Post)
# Enum.each(posts, fn(post) -> 
#   Enum.each(comments, fn(comment) -> 
#     Ecto.build_assoc(post, :comments, comment) |>Repo.insert!
#   end)
# end)








