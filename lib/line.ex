defmodule Line do

  def post!(path, json) do
    config = Application.get_env(:yontaku, __MODULE__, [])

    url = Path.join(config[:url], path)
    headers = [
      {"Content-Type", "application/json; charset=UTF-8"},
      {"Authorization", "Bearer " <> config[:token]}
    ]

    HTTPoison.post!(url, json, headers)
  end

  def reply!(message, token) do
      json = %{
        replyToken: token,
        messages: [message]
      } |> Poison.encode!

      post!("message/reply", json)
  end

  def fetch!(path) do
    config = Application.get_env(:yontaku, __MODULE__, [])
    url = Path.join(config[:url], path)
    headers = [
      {"Authorization", "Bearer " <> config[:token]}
    ]

    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(url, headers)
    body |> Poison.decode!
  end

end