defmodule Yontaku.Exercises do
  @moduledoc """
  The Exercises context.
  """

  import Ecto.Query, warn: false
  alias Yontaku.Repo

  alias Yontaku.Exercises.Question

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{source: %Question{}}

  """
  def change_question(%Question{} = question) do
    Question.changeset(question, %{})
  end

  @doc """
  Generates a single template message.

  ## Examples

      iex> gen_yontaku!()
      %{type: "template", template: %{}}

  """

  def gen_yontaku!(rank) do
    query = "SELECT * FROM questions WHERE rank = #{rank} ORDER BY RANDOM() LIMIT 1"
    res = Ecto.Adapters.SQL.query!(Repo, query, [])
    cols = Enum.map(res.columns, &(String.to_atom(&1)))
    question = struct(Question, Enum.zip(cols, hd(res.rows)))

    template = %{
      type: "buttons",
      title: "Rank#{question.rank}",
      text: question.sentence,
      actions: Enum.map(0..3, &gen_postback(&1, question))
    }

    %{type: "template", altText: question.sentence, template: template}
  end

  defp gen_postback(num, question) do
    labels = [question.item0, question.item1, question.item2, question.item3]
    %{
      type: "postback",
      label: Enum.at(labels, num),
      data: "#{question.id}:#{Enum.at(labels, num)}:#{judge(num, question.answer)}:#{question.description}"
    }
  end

  defp judge(num, answer) do
    if num == answer, do: "correct", else: "wrong"
  end

  def get_ranks() do
    Repo.all(
      from q in Question,
      distinct: [desc: q.rank],
      select: q.rank
    )
  end

  def count_questions() do
    Repo.all(
      from q in Question,
      group_by: q.rank,
      order_by: [asc: q.rank],
      select: {q.rank, count(q.id)}
    )
  end

end
