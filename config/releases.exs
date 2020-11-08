config :base_api, BaseApi.Repo,
  username: System.fetch_env!("DATABASE_USERNAME"),
  password: System.fetch_env!("DATABASE_PASSWORD"),
  database: System.fetch_env!("DATABASE_NAME"),
  hostname: System.fetch_env!("DATABASE_HOSTNAME")
