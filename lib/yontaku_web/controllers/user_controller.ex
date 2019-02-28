defmodule YontakuWeb.UserController do
  use YontakuWeb, :controller

  alias Yontaku.Accounts
  alias Yontaku.Accounts.User

  def index(conn, %{"replyToken" => token, "source" => source}) do
    profile = Line.fetch!("profile/" <> source["userId"])
    achievements = Accounts.get_achievements(source["userId"])
    totals = Yontaku.Exercises.count_questions()

    text = ~s"""
    #{profile["displayName"]} さんの進捗

    #{print(achievements, totals, "")}
    """

    Line.reply!(
      %{type: "text", text: String.slice(text, 0..-2)},
      token
    )
  end

  defp print([{num_a, a} | t_a], [{num_t, t} | t_t], text) do
    if num_a != num_t, do: raise("An error occurred: YontakuWeb.UserController.print/3")
    line = ~s"""
    Rank#{num_t}: #{a}/#{t}
    """

    print(t_a, t_t, text <> line)
  end

  defp print([], [{num_t, t} | t_t], text) do
    line = ~s"""
    Rank#{num_t}: 0/#{t}
    """

    print([], t_t, text <> line)
  end

  defp print([], [], text) do
    String.slice(text, 0..-2)
  end

  def create(conn, %{"replyToken" => token, "source" => source}) do
    profile = Line.fetch!("profile/" <> source["userId"])
    Accounts.create_user!(%{id: profile["userId"], name: profile["displayName"]})

    Line.reply!(
      %{type: "text", text: "こんにちは " <> profile["displayName"] <> " さん。"},
      token
    )
  end

  def update(conn, %{"replyToken" => token, "source" => source}) do
    user =
      Accounts.get_user!(source["userId"])
      |> Accounts.change_user_rank!

    Line.reply!(
      %{type: "text", text: "Rank#{user.rank}に変更しました。"},
      token
    )
  end

end