defmodule Api.Repo.Migrations.AlterPostTableBodyToText do
  use Ecto.Migration

  def change do
    alter table("posts") do
      modify :body, :text
    end
  end
end
