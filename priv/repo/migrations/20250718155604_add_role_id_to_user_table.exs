defmodule TimeAttendance.Repo.Migrations.AddRoleIdToUserTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role_id, references("roles", type: :binary_id, on_delete: :delete_all ), null: false
    end
  end
end
