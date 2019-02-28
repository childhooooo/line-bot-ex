defmodule Yontaku.Exercises.Question do
  use Ecto.Schema
  import Ecto.Changeset


  schema "questions" do
    field :answer, :integer
    field :description, :string
    field :item0, :string
    field :item1, :string
    field :item2, :string
    field :item3, :string
    field :sentence, :string
    field :rank, :integer

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:sentence, :item0, :item1, :item2, :item3, :answer, :description, :rank])
    |> validate_required([:sentence, :item0, :item1, :item2, :item3, :answer, :description, :rank])
  end
end
