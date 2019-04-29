defmodule Api.Repo.Migrations.CreateDrafts do
  use Ecto.Migration

  def change do
    create table(:drafts) do
      add :body, :text
      add :title, :string
      add :featured_image, :string
      add :user_id, references(:users)

      timestamps()
    end

  end
end
