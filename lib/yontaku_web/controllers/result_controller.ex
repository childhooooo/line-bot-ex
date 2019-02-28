defmodule YontakuWeb.ResultController do
  use YontakuWeb, :controller

  alias Yontaku.Accounts
  alias Yontaku.Accounts.Result

  def update(conn, %{"replyToken" => token, "source" => source, "postback" => postback}) do
    [question_id, answer, judge, description] = String.split(postback["data"], ":")
    user_id = source["userId"]
    question_id = String.to_integer(question_id)

    Accounts.answer(judge, user_id, question_id)

    text = ~s"""
    #{mark(judge)}: #{answer}

    #{description}
    """

    Line.reply!(
      %{type: "text", text: String.slice(text, 0..-2)},
      token
    )
  end

  defp mark(result) do
    if result == "correct", do: "○", else: "×"
  end

end