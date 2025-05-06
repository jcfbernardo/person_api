defmodule PersonApiWeb.PersonFlowTest do
  use PersonApiWeb.ConnCase

  @valid_person %{
    name: "Elixir QA",
    email: "qa@exemplo.com",
    age: 30
  }

  @updated_person %{
    name: "QA Atualizado",
    email: "qa@update.com",
    age: 31
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "Fluxo completo de criação, leitura, atualização e exclusão", %{conn: conn} do
    # 1. Cria pessoa
    conn = post(conn, ~p"/api/people", person: @valid_person)
    assert %{"id" => id} = json_response(conn, 201)["data"]

    # 2. Busca pessoa
    conn = get(conn, ~p"/api/people/#{id}")

    assert %{
             "id" => ^id,
             "name" => "Elixir QA",
             "email" => "qa@exemplo.com",
             "age" => 30
           } = json_response(conn, 200)["data"]

    # 3. Atualiza pessoa
    conn = put(conn, ~p"/api/people/#{id}", person: @updated_person)
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    # 4. Verifica atualização
    conn = get(conn, ~p"/api/people/#{id}")

    assert %{
             "id" => ^id,
             "name" => "QA Atualizado",
             "email" => "qa@update.com",
             "age" => 31
           } = json_response(conn, 200)["data"]

    # 5. Deleta pessoa
    conn = delete(conn, ~p"/api/people/#{id}")
    assert response(conn, 204)

    # 6. Verifica que foi removida
    assert_error_sent 404, fn ->
      get(conn, ~p"/api/people/#{id}")
    end
  end
end
