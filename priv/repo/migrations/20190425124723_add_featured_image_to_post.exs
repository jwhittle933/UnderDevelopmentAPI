defmodule Api.Repo.Migrations.AddFeaturedImageToPost do
  use Ecto.Migration

  def change do
    alter table("posts") do
      add :featured_image, :string, default: ""
    end
  end
end
