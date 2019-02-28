defmodule Yontaku.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string

      timestamps()
    end

    create unique_index(:users, [:line_id])
  end
end
