FROM elixir:latest

WORKDIR /app

RUN mix local.hex --force && \
    mix archive.install --force hex phx_new 1.4.0 && \
    mix local.rebar --force