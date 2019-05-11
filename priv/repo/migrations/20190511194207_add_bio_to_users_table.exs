defmodule Api.Repo.Migrations.AddBioToUsersTable do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :bio, :text, default: "No bio provided by the author."
    end
  end
end
