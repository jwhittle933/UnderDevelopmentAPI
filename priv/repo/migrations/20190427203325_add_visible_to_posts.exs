defmodule Api.Repo.Migrations.AddVisibleToPosts do
  use Ecto.Migration

  def change do
    alter table("posts") do
      add :visible, :boolean
    end
  end
end
