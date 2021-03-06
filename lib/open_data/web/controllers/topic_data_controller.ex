defmodule OpenData.Web.TopicDataController do
  use OpenData.Web, :controller

  alias OpenData.Ghostbuster
  alias OpenData.Ghostbuster.Topic

  action_fallback OpenData.Web.FallbackController
import IEx
  def index(conn, params) do
    results = Ghostbuster.list_topic_records(Map.get(params, "datastore_id"), Map.get(params, "topic_id"))
    conn
    |> json(results)

  end

  def create(conn, params) do
    with {:ok, row} <- Ghostbuster.create_topic_record(Map.get(params, "topic_id"), Map.get(params, "fields")) do
      conn
      |> put_status(:created)
      |> json(row)
    end
  end

  def show(conn, params) do
    IEx.pry
    topic = Ghostbuster.get_topic_data!(Map.get(params, "topic_id"))
    render(conn, "show.json", topic: topic)
  end


end
