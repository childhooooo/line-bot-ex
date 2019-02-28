defmodule YontakuWeb.QuestionController do
  use YontakuWeb, :controller

  alias Yontaku.Exercises
  alias Yontaku.Exercises.Question
  alias Yontaku.Accounts

  def index(conn, %{"replyToken" => token, "source" => source}) do
    user = Accounts.get_user!(source["userId"])
    Exercises.gen_yontaku!(user.rank)
    |> Line.reply!(token)
  end

end