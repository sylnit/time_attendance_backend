defmodule TimeAttendance.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeAttendance.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def test_first_name, do: "test firstname"
  def test_last_name, do: "test lastname"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      first_name: test_first_name(),
      last_name: test_last_name(),
      email: unique_user_email(),
      password: valid_user_password(),
      role_id: nil
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> TimeAttendance.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "test role"
      })
      |> TimeAttendance.Accounts.create_role()

    role
  end
end
