use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :groupher_server, GroupherServerWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :groupher_server, Helper.Guardian,
  issuer: "groupher_server",
  secret_key: "kSTPDbCUSRhiEmv86eYMUplL7xI5fDa/+6MWKzK2VYGxjwL0XGHHVJiSPNPe9hJe"

config :groupher_server, :test,
  # 成都电信 ip, for test use
  remote_ip: "171.223.96.88"

# Configure your database
config :groupher_server, GroupherServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "groupher_server_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :groupher_server, :github_oauth,
  client_id: "3b4281c5e54ffd801f85",
  client_secret: "51f04dd8239b27f00a39a647ef3704de4c5ddc26"

#  config email services
config :groupher_server, GroupherServer.Mailer, adapter: Bamboo.TestAdapter
