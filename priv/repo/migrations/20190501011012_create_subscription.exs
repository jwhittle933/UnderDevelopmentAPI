defmodule Api.Repo.Migrations.CreateSubscription do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :name, :string
      add :email, :string

      timestamps()
    end
  end
end
