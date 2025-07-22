defmodule TimeAttendanceWeb.RoleControllerTest do
  use TimeAttendanceWeb.ConnCase

  import TimeAttendance.AccountsFixtures

  alias TimeAttendance.Accounts.Role
  alias TimeAttendance.Accounts

  @create_attrs %{
    name: "test role"
  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    role = role_fixture()
    user = user_fixture(%{role_id: role.id})
    token = Accounts.create_user_api_token(user)
    {:ok, conn: put_req_header(conn, "accept", "application/json") |> put_req_header("authorization", "Bearer "<>token)}
  end

  describe "index" do
    test "lists all roles", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/roles")
      assert [%{"name" => "test role"}] = json_response(conn, 200)["data"]
    end
  end

  describe "create role" do
    test "renders role when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/roles", role: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/roles", role: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update role" do
    setup [:create_role]

    test "renders role when data is valid", %{conn: conn, role: %Role{id: id} = role} do
      conn = put(conn, ~p"/api/v1/roles/#{role}", role: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/v1/roles/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, role: role} do
      conn = put(conn, ~p"/api/v1/roles/#{role}", role: @invalid_attrs)
      assert json_response(conn, 200)["errors"] != %{}
    end
  end

  describe "delete role" do
    setup [:create_role]

    test "deletes chosen role", %{conn: conn, role: role} do
      conn = delete(conn, ~p"/api/v1/roles/#{role}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/roles/#{role}")
      end
    end
  end

  defp create_role(_) do
    role = role_fixture()
    %{role: role}
  end
end
