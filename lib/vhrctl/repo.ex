defmodule VhrCtl.Repo do
  use Ecto.Repo,
    otp_app: :vhrctl,
    adapter: Ecto.Adapters.Postgres
end
