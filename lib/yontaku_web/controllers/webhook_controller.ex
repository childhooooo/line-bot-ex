defmodule YontakuWeb.WebhookController do
  use YontakuWeb, :controller

  def index(conn, _params) do
    send_resp(conn, :ok, "test")
  end

  def webhook(conn, %{"events" => events}) do
    for e <- events do
      case e["type"] do
        "follow" -> router(conn, "create:user", e)
        "message" -> router(conn, e["message"]["text"], e)
        "postback" -> router(conn, "update:result", e)
      end
    end

    send_resp(conn, :no_content, "")
  end

  defp router(conn, route, event) do
    case route do
      "進捗" -> YontakuWeb.UserController.index(conn, event)
      "create:user" -> YontakuWeb.UserController.create(conn, event)
      "ランク変更" -> YontakuWeb.UserController.update(conn, event)
      "出題" -> YontakuWeb.QuestionController.index(conn, event)
      "このアプリについて" -> YontakuWeb.BotController.info(conn, event)
      "help:bot" -> YontakuWeb.BotController.help(conn, event)
      "update:result" -> YontakuWeb.ResultController.update(conn, event)
    end
  end

end