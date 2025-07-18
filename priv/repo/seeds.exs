# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeAttendance.Repo.insert!(%TimeAttendance.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias TimeAttendance.Repo
alias TimeAttendance.Accounts.Role

roles = ["Admin", "Staff"]
Enum.map(roles, fn role ->
  if Repo.get_by(Role, name: role) == :nil do
    Repo.insert(%Role{name: role})
  end
end)
