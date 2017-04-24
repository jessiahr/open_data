defmodule OpenData.Web.TopicController do
  use OpenData.Web, :controller

  alias OpenData.Ghostbuster
  alias OpenData.Ghostbuster.Topic
import IEx
  action_fallback OpenData.Web.FallbackController

  def index(conn, params) do
    topics = Ghostbuster.list_topics(params)
    render(conn, "index.json", topics: topics)
  end

  def create(conn, %{"topic" => topic_params, "datastore_id" => datastore_id}) do
    merged_topic_params = Map.put(topic_params, "datastore_id", datastore_id)
    with {:ok, %Topic{} = topic} <- Ghostbuster.create_topic(merged_topic_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", datastore_topic_path(conn, :show, datastore_id, topic))
      |> render("show.json", topic: topic)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Ghostbuster.get_topic!(id)
    render(conn, "show.json", topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Ghostbuster.get_topic!(id)

    with {:ok, %Topic{} = topic} <- Ghostbuster.update_topic(topic, topic_params) do
      render(conn, "show.json", topic: topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Ghostbuster.get_topic!(id)
    with {:ok, %Topic{}} <- Ghostbuster.delete_topic(topic) do
      send_resp(conn, :no_content, "")
    end
  end

  def create_table(conn, %{"topic_id" => id}) do
    topic = Ghostbuster.get_topic!(id)
    case Ghostbuster.create_topic_tables(topic) do
      {:ok, response} ->
        conn
        |> json(%{response: response})
      {:error, %Postgrex.Error{} = error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: error})
    end
  end
end
