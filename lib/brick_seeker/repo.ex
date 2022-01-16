defmodule BrickSeeker.Repo do
  use Ecto.Repo,
    otp_app: :brick_seeker,
    adapter: Ecto.Adapters.Postgres
end
