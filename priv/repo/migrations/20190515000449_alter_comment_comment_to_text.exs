defmodule Api.Repo.Migrations.AlterCommentCommentToText do
  use Ecto.Migration

  def change do
    alter table("comments") do
      modify :comment, :text
    end
  end
end
