defmodule Api.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comment) do
      add :name, :string
      add :comment, :string
      add :user_id, references(:users)

      timestamps()
    end

  end
end
