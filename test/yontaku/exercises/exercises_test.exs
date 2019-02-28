defmodule Yontaku.ExercisesTest do
  use Yontaku.DataCase

  alias Yontaku.Exercises

  describe "questions" do
    alias Yontaku.Exercises.Question

    @valid_attrs %{answer: 42, description: "some description", item0: "some item0", item1: "some item1", item3: "some item3", ititem2: "some ititem2", sentence: "some sentence"}
    @update_attrs %{answer: 43, description: "some updated description", item0: "some updated item0", item1: "some updated item1", item3: "some updated item3", ititem2: "some updated ititem2", sentence: "some updated sentence"}
    @invalid_attrs %{answer: nil, description: nil, item0: nil, item1: nil, item3: nil, ititem2: nil, sentence: nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Exercises.create_question()

      question
    end

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Exercises.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Exercises.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Exercises.create_question(@valid_attrs)
      assert question.answer == 42
      assert question.description == "some description"
      assert question.item0 == "some item0"
      assert question.item1 == "some item1"
      assert question.item3 == "some item3"
      assert question.ititem2 == "some ititem2"
      assert question.sentence == "some sentence"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exercises.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, %Question{} = question} = Exercises.update_question(question, @update_attrs)
      assert question.answer == 43
      assert question.description == "some updated description"
      assert question.item0 == "some updated item0"
      assert question.item1 == "some updated item1"
      assert question.item3 == "some updated item3"
      assert question.ititem2 == "some updated ititem2"
      assert question.sentence == "some updated sentence"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Exercises.update_question(question, @invalid_attrs)
      assert question == Exercises.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Exercises.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Exercises.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Exercises.change_question(question)
    end
  end
end
