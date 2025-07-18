defmodule TimeAttendanceWeb.API.V1.Auth.UserRegistrationController do
  use TimeAttendanceWeb, :controller

  import TimeAttendanceWeb.ErrorHelpers

  alias TimeAttendance.Accounts

  def create(conn, %{"user" => user_params}) do
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

  def create(conn, _params) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{
      error: "Call to improper function"
    })
  end
end
