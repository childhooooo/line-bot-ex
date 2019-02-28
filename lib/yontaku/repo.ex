defmodule Yontaku.Repo do
  use Ecto.Repo,
    otp_app: :yontaku,
    adapter: Ecto.Adapters.Postgres
end
