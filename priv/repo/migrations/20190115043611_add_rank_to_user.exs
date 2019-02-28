defmodule Yontaku.Repo.Migrations.AddRankToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :rank, :integer
    end
  end
end
