defmodule Yontaku.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Yontaku.Repo

  alias Yontaku.Accounts.User
  alias Yontaku.Accounts.Result
  alias Yontaku.Exercises

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      %User{}

  """
  def create_user!(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      %User{}

  """
  def update_user!(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def change_user_rank!(%User{} = user) do
    ranks = Exercises.get_ranks
    update_user!(user, %{rank: next_rank(user.rank, ranks)})
  end

  defp next_rank(now, ranks) do
    case Enum.filter(ranks, fn x -> now < x end) do
      [] -> 0
      [head | _] -> head
    end
  end

  @doc """
  Gets a single result.

  Returns nil if no result was found. Raises if more than one entry.

  ## Examples

      iex> get_the_result("abc", 123)
      %Result{}

      iex> get_result!("def", 456)
      nil

  """
  def get_the_result!(user_id, question_id) do
    Repo.one!(
      from r in Result,
      where: r.user_id == ^user_id and r.question_id == ^question_id
    )
  end

  @doc """
  Gets a single result.

  Raises `Ecto.NoResultsError` if the Result does not exist.

  ## Examples

      iex> get_result!(123)
      %Result{}

      iex> get_result!(456)
      ** (Ecto.NoResultsError)

  """
  def get_result!(id), do: Repo.get!(Result, id)

  @doc """
  Creates a result.

  Raises if the changeset is invalid.

  ## Examples

      iex> create_result(%{field: value})
      %Result{}

  """
  def create_result!(attrs \\ %{}) do
    %Result{}
    |> Result.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a result.

  Raises if the changeset is invalid.

  ## Examples

      iex> update_result(result, %{field: new_value})
      %Result{}

  """
  def update_result!(%Result{} = result, attrs) do
    result
    |> Result.changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Deletes a Result.

  ## Examples

      iex> delete_result(result)
      {:ok, %Result{}}

      iex> delete_result(result)
      {:error, %Ecto.Changeset{}}

  """
  def delete_result(%Result{} = result) do
    Repo.delete(result)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking result changes.

  ## Examples

      iex> change_result(result)
      %Ecto.Changeset{source: %Result{}}

  """
  def change_result(%Result{} = result) do
    Result.changeset(result, %{})
  end

  def answer(judge, user_id, question_id) do
    case judge do
      "correct" -> answer_correct(user_id, question_id)
      _ -> answer_wrong(user_id, question_id)
    end
  end

  def answer_correct(user_id, question_id) do
    case get_the_result!(user_id, question_id) do
      nil ->
        create_result!(%{user_id: user_id, question_id: question_id, count: 1})
      result ->
        update_result!(result, %{count: count_up(result.count)})
    end
  end

  def answer_wrong(user_id, question_id) do
    case get_the_result!(user_id, question_id) do
      nil ->
        create_result!(%{user_id: user_id, question_id: question_id, count: 0})
      result ->
        update_result!(result, %{count: count_down(result.count)})
    end
  end

  defp count_up(count) do
    count + 1
  end

  defp count_down(count) do
    if count > 0, do: count - 1, else: 0
  end

  def get_achievements(user_id) do
    config = Application.get_env(:yontaku, Yontaku, [])

    query =
      from r in Result,
      join: q in Yontaku.Exercises.Question,
        where: q.id == r.question_id

    Repo.all(
      from [r, q] in query,
        where: r.count >= ^config[:threshold],
        group_by: q.rank,
        order_by: [asc: q.rank],
        select: {q.rank, count(r.id)}
    )
  end
end
