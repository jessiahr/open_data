defmodule OpenData.Web.TopicController do
  use OpenData.Web, :controller

  alias OpenData.Ghostbuster
  alias OpenData.Ghostbuster.Topic

  action_fallback OpenData.Web.FallbackController

  def index(conn, _params) do
    topics = Ghostbuster.list_topics()
    render(conn, "index.json", topics: topics)
  end

  def create(conn, %{"topic" => topic_params}) do
    with {:ok, %Topic{} = topic} <- Ghostbuster.create_topic(topic_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", datastore_topic_path(conn, :show, topic))
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
end
