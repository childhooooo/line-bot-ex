defmodule Yontaku.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :sentence, :string
      add :item0, :string
      add :item1, :string
      add :item2, :string
      add :item3, :string
      add :answer, :integer
      add :description, :string

      timestamps()
    end

  end
end
