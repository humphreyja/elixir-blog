# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :blog,
  ecto_repos: [Blog.Repo],
  authorization_server_sign_in: "http://localhost:4000/?client_key=blog",
  authorization_server_sign_out: "http://localhost:4000/sign-out/?client_key=blog"

config :jwt,
  secret_base: "sso_standard_secret_1234567890",
  client_secret: "blog_secret"

# Configures the endpoint
config :blog, Blog.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vOONTW3pj9JVS2d6nUyge9XAnuYab+4IreKULBv46gPaAYOivFK0zHBlUPr8E4cT",
  render_errors: [view: Blog.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Blog.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
