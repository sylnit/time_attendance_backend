defmodule TimeAttendance.Repo do
  use Ecto.Repo,
    otp_app: :time_attendance,
    adapter: Ecto.Adapters.Postgres
end
