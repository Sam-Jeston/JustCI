# JustCI

An easy to use CI tool written in Elixir.

This project has only just started and is not yet functional.

Phoenix commands:
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`
  * Model generation `mix phoenix.gen.model Post posts title user_id:references:users`

Use Ngrok for local testing of CI integration!
`ngrok http 4000`

Continue to follow this for Github Integration - https://developer.github.com/guides/building-a-ci-server/
