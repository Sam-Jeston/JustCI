# JustCI

An easy to use CI tool written in Elixir using the Phoenix Framework.

This project has only just started and is not yet functional. It is under active development.

## Motivations

I am a big fan of TravisCI however am looking to develop a simple, self-hosted
CI platform with first-class Docker support.

The CI platform should:
  * Run all jobs within Docker containers
  * Cache docker build layers for faster build times for jobs that run Docker build commands
  * Be incredibly easy to start using. (AMIs, install and boot scripts etc)
  * Have Github webhook support

Upcoming features:
  * Complete Docker support
  * Selection of build runtime
  * Selection of build dependencies (dbs etc)
  * Association of explicit private keys with templates
  * Reset password from setting and via email

Technical Debt:
  * Lack of test coverage
  * Completely unstyled UI
  * jQuery frontend

Phoenix commands:
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`
  * Model generation `mix phoenix.gen.model Post posts title user_id:references:users`

Use Ngrok for local testing of CI integration!
`ngrok http 4000`

Github Integration Guide
  * https://developer.github.com/guides/building-a-ci-server/
