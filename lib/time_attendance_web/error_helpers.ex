defmodule TimeAttendanceWeb.ErrorHelpers do
  def translate_error(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
      Phoenix.Naming.humanize(msg)
    end)
  end
end
