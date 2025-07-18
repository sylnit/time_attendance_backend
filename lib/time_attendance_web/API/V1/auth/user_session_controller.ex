defmodule TimeAttendanceWeb.API.V1.Auth.UserSessionController do
  use TimeAttendanceWeb, :controller

  alias TimeAttendance.Accounts
  alias TimeAttendanceWeb.UserAuth

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      token = Accounts.create_user_api_token(user)
      conn
      |> put_status(:ok)
      |> json(%{
        message: "Login successful",
        data: %{
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          token: token
        }
      })
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> json(%{
        message: "Invalid email or password"
      })
    end
  end
end
