# Polymorphic Productions

[![Maintainability](https://api.codeclimate.com/v1/badges/c8d65a2ee58ddc7e3882/maintainability)](https://codeclimate.com/github/PolymorphicProductions/polymorphic.productions/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/PolymorphicProductions/polymorphic.productions/badge.svg?branch=master)](https://coveralls.io/github/PolymorphicProductions/polymorphic.productions?branch=master) [![CircleCI](https://circleci.com/gh/PolymorphicProductions/polymorphic.productions.svg?style=svg)](https://circleci.com/gh/PolymorphicProductions/polymorphic.productions)

This repo is the source file for [`https://polymorphic.productions`](https://polymorphic.productions)

I built this project as my personal portfilio, blog and online presense.

## Local Dev

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Generate local certs `mix phx.gen.cert` ("make sure to trust cert")
- Create and migrate your database with `mix ecto.create && mix ecto.migrate`
- Install Node.js dependencies with `cd assets && yarn install`
- Start Phoenix endpoint with `mix phx.server`

Note: local development requires some secrets to run fully.

```
config :polymorphic_productions, PolymorphicProductionsWeb.Mailer,
  api_key: "MAIL_GUN_KEY",
  domain: "MAIL_GUN_DOMAIN"

config :ex_aws,
  access_key_id: "IAM key",
  secret_access_key: "IAM Secret"
```

Now you can visit [`https://localhost:4001`](https://localhost:4001) from your browser.

## Deployments

- Build release with `edeliver build release`
- Deploy with `mix edeliver deploy release|upgrade [[to] staging|production]`
- Migrate with `mix edeliver migrate [staging|production] [up|down]`
- Restart with `mix edeliver start|stop|restart|ping|version [staging|production]`

## Learn more

- Build with 🍆 by [`Josh Chernoff`](https://polymorphic.productions/contact)
- Official website: http://www.phoenixframework.org/
- Guides: http://phoenixframework.org/docs/overview
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix
