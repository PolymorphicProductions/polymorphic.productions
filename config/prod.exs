use Mix.Config

config :polymorphic_productions,
  cors_origin: "https://polymorphic.productions"

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :polymorphic_productions, PolymorphicProductionsWeb.Endpoint,
  http: [
    port: 4000
    # cipher_suite: :strong,
    # keyfile: "/etc/letsencrypt/live/polymorphic.productions/privkey.pem",
    # certfile: "/etc/letsencrypt/live/polymorphic.productions/cert.pem",
    # cacertfile: "/etc/letsencrypt/live/polymorphic.productions/chain.pem"
  ],
  url: [host: "polymorphic.productions", scheme: "https", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  version: Mix.Project.config()[:version],
  debug_errors: false,
  code_reloader: false

# Do not print debug messages in production
config :logger, level: :info

config :polymorphic_productions, PolymorphicProductionsWeb.Mailer, adapter: Bamboo.MailgunAdapter

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :ex_aws,
  s3: [
    scheme: "https://",
    # Note You must specify the region in the host s3.{region}.amazonaws.com
    host: "polymorphic-productions.s3.us-west-2.amazonaws.com",
    # Note even though you have specified host to include the
    # region you still have to set it in the config. :(
    region: "us-west-2"
  ]

config :polymorphic_productions, render_tracking: true
# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :polymorphic_productions, PolymorphicProductionsWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [:inet6,
#               port: 443,
#               cipher_suite: :strong,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :polymorphic_productions, PolymorphicProductionsWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases (distillery)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :polymorphic_productions, PolymorphicProductionsWeb.Endpoint, server: true
#
# Note you can't rely on `System.get_env/1` when using releases.
# See the releases documentation accordingly.

# Finally import the config/prod.secret.exs which should be versioned
# separately.

import_config "prod.secret.exs"
