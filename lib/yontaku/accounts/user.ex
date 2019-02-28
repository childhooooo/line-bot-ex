defmodule Yontaku.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "users" do
    field :name, :string
    field :rank, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :rank, :name])
    |> validate_required([:id, :rank, :name])
    |> unique_constraint(:id)
  end
end
