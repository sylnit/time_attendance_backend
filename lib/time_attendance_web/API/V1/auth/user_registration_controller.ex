defmodule TimeAttendanceWeb.API.V1.Auth.UserRegistrationController do
  use TimeAttendanceWeb, :controller

  import TimeAttendanceWeb.ErrorHelpers

  alias TimeAttendance.Accounts

  @default_role "Staff"

  def create(conn, %{"user" => user_params}) do
    user_role = Accounts.get_role_by_name(@default_role)
    if user_role == :nil do
      conn
      |> json(%{
        message: "Appropriate access level not found"
      })
    else
      user_params = Map.put(user_params, "role_id", user_role.id)
      case Accounts.register_user(user_params) do
        {:ok, user} ->
          token = Accounts.create_user_api_token(user)
          conn
          |> json(%{
            data: %{
              first_name: user.first_name,
              last_name: user.last_name,
              email: user.email,
              token: token
            }
          })

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> json(%{
            message: "Registration failed",
            errors: translate_error(changeset)
          })
      end
    end

  end

  def create(conn, _params) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{
      error: "Call to improper function"
    })
  end
end
