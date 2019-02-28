defmodule Yontaku.Repo.Migrations.AddRankToQuestions do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :rank, :integer
    end
  end
end
