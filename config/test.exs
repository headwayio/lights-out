import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lights_out_game, LightsOutGameWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "9ljDvISTG/k65ABIUOzfbLM5KKNdDgIfA60W92z5+0sqoiY3lgSJbJj+k50cVjuo",
  server: false

# In test we don't send emails.
config :lights_out_game, LightsOutGame.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
