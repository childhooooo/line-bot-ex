defmodule Yontaku.AchievesTest do
  use Yontaku.DataCase

  alias Yontaku.Achieves

  describe "results" do
    alias Yontaku.Achieves.Result

    @valid_attrs %{count: 42}
    @update_attrs %{count: 43}
    @invalid_attrs %{count: nil}

    def result_fixture(attrs \\ %{}) do
      {:ok, result} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Achieves.create_result()

      result
    end

    test "list_results/0 returns all results" do
      result = result_fixture()
      assert Achieves.list_results() == [result]
    end

    test "get_result!/1 returns the result with given id" do
      result = result_fixture()
      assert Achieves.get_result!(result.id) == result
    end

    test "create_result/1 with valid data creates a result" do
      assert {:ok, %Result{} = result} = Achieves.create_result(@valid_attrs)
      assert result.count == 42
    end

    test "create_result/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Achieves.create_result(@invalid_attrs)
    end

    test "update_result/2 with valid data updates the result" do
      result = result_fixture()
      assert {:ok, %Result{} = result} = Achieves.update_result(result, @update_attrs)
      assert result.count == 43
    end

    test "update_result/2 with invalid data returns error changeset" do
      result = result_fixture()
      assert {:error, %Ecto.Changeset{}} = Achieves.update_result(result, @invalid_attrs)
      assert result == Achieves.get_result!(result.id)
    end

    test "delete_result/1 deletes the result" do
      result = result_fixture()
      assert {:ok, %Result{}} = Achieves.delete_result(result)
      assert_raise Ecto.NoResultsError, fn -> Achieves.get_result!(result.id) end
    end

    test "change_result/1 returns a result changeset" do
      result = result_fixture()
      assert %Ecto.Changeset{} = Achieves.change_result(result)
    end
  end
end
