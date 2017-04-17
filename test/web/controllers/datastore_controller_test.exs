defmodule OpenData.Web.DatastoreControllerTest do
  use OpenData.Web.ConnCase

  alias OpenData.Ghostbuster
  alias OpenData.Ghostbuster.Datastore

  @create_attrs %{database: "some database", hostname: "some hostname", password: "some password", username: "some username"}
  @update_attrs %{database: "some updated database", hostname: "some updated hostname", password: "some updated password", username: "some updated username"}
  @invalid_attrs %{database: nil, hostname: nil, password: nil, username: nil}

  def fixture(:datastore) do
    {:ok, datastore} = Ghostbuster.create_datastore(@create_attrs)
    datastore
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, datastore_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates datastore and renders datastore when data is valid", %{conn: conn} do
    conn = post conn, datastore_path(conn, :create), datastore: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, datastore_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "database" => "some database",
      "hostname" => "some hostname",
      "password" => "some password",
      "username" => "some username"}
  end

  test "does not create datastore and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, datastore_path(conn, :create), datastore: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen datastore and renders datastore when data is valid", %{conn: conn} do
    %Datastore{id: id} = datastore = fixture(:datastore)
    conn = put conn, datastore_path(conn, :update, datastore), datastore: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, datastore_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "database" => "some updated database",
      "hostname" => "some updated hostname",
      "password" => "some updated password",
      "username" => "some updated username"}
  end

  test "does not update chosen datastore and renders errors when data is invalid", %{conn: conn} do
    datastore = fixture(:datastore)
    conn = put conn, datastore_path(conn, :update, datastore), datastore: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen datastore", %{conn: conn} do
    datastore = fixture(:datastore)
    conn = delete conn, datastore_path(conn, :delete, datastore)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, datastore_path(conn, :show, datastore)
    end
  end
end
