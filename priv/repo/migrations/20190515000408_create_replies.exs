defmodule Api.Repo.Migrations.CreateReplies do
  use Ecto.Migration

  def change do
    create table(:replies) do
      add :reply, :text
      add :name, :string
      add :comment_id, references(:comments)

      timestamps()
    end
  end
end
