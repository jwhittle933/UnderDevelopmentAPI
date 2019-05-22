defmodule Api.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :name, :string
      add :comment, :string
      add :post_id, references(:posts)

      timestamps()
    end
  end
end
