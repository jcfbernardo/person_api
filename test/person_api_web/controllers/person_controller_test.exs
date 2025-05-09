defmodule PersonApiWeb.PersonControllerTest do
  use PersonApiWeb.ConnCase

  import PersonApi.PeopleFixtures

  alias PersonApi.People.Person

  @create_attrs %{
    name: "some name",
    age: 42,
    email: "some email"
  }
  @update_attrs %{
    name: "some updated name",
    age: 43,
    email: "some updated email"
  }
  @invalid_attrs %{name: nil, age: nil, email: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all people", %{conn: conn} do
      conn = get(conn, ~p"/api/people")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create person" do
    test "renders person when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/people", person: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/people/#{id}")

      assert %{
               "id" => ^id,
               "age" => 42,
               "email" => "some email",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/people", person: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update person" do
    setup [:create_person]

    test "renders person when data is valid", %{conn: conn, person: %Person{id: id} = person} do
      conn = put(conn, ~p"/api/people/#{person}", person: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/people/#{id}")

      assert %{
               "id" => ^id,
               "age" => 43,
               "email" => "some updated email",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, person: person} do
      conn = put(conn, ~p"/api/people/#{person}", person: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete person" do
    setup [:create_person]

    test "deletes chosen person", %{conn: conn, person: person} do
      conn = delete(conn, ~p"/api/people/#{person}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/people/#{person}")
      end
    end
  end

  defp create_person(_) do
    person = person_fixture()
    %{person: person}
  end
end
