defmodule OpenData.Web.TopicControllerTest do
  use OpenData.Web.ConnCase

  alias OpenData.Ghostbuster
  alias OpenData.Ghostbuster.Topic

  @create_attrs %{datastore_id: 42, name: "some name", schema: %{}}
  @update_attrs %{datastore_id: 43, name: "some updated name", schema: %{}}
  @invalid_attrs %{datastore_id: nil, name: nil, schema: nil}

  def fixture(:topic) do
    {:ok, topic} = Ghostbuster.create_topic(@create_attrs)
    topic
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, topic_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates topic and renders topic when data is valid", %{conn: conn} do
    conn = post conn, topic_path(conn, :create), topic: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, topic_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "datastore_id" => 42,
      "name" => "some name",
      "schema" => %{}}
  end

  test "does not create topic and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, topic_path(conn, :create), topic: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen topic and renders topic when data is valid", %{conn: conn} do
    %Topic{id: id} = topic = fixture(:topic)
    conn = put conn, topic_path(conn, :update, topic), topic: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, topic_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "datastore_id" => 43,
      "name" => "some updated name",
      "schema" => %{}}
  end

  test "does not update chosen topic and renders errors when data is invalid", %{conn: conn} do
    topic = fixture(:topic)
    conn = put conn, topic_path(conn, :update, topic), topic: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen topic", %{conn: conn} do
    topic = fixture(:topic)
    conn = delete conn, topic_path(conn, :delete, topic)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, topic_path(conn, :show, topic)
    end
  end
end
