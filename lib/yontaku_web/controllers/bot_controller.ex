defmodule YontakuWeb.BotController do
  use YontakuWeb, :controller

  def info(conn, %{"replyToken" => token}) do
    text = ~s"""
    アプリ名: Yontaku!
    作成者: Hikaru Otabe
    概要:
    登録した4択問題を完璧にマスターするためのBOTです。
    英単語などの勉強に役立てましょう！
    """

    Line.reply!(
      %{type: "text", text: String.slice(text, 0..-2)},
      token
    )
  end

  def help(conn, %{"replyToken" => token}) do
    text = ~s"""
    ボタンを押してみて！
    """

    Line.reply!(
      %{type: "text", text: String.slice(text, 0..-2)},
      token
    )
  end

end