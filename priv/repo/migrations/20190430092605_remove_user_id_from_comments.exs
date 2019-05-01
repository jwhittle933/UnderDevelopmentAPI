defmodule Api.Repo.Migrations.RemoveUserIdFromComments do
  use Ecto.Migration

  def change do
    alter table("comments") do
      remove :user_id
    end
  end
end
