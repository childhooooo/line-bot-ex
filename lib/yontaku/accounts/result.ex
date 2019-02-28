defmodule Yontaku.Accounts.Result do
  use Ecto.Schema
  import Ecto.Changeset


  schema "results" do
    field :count, :integer
    field :question_id, :integer
    field :user_id, :string

    timestamps()
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, [:user_id, :question_id, :count])
    |> validate_required([:user_id, :question_id, :count])
  end
end