defmodule OpenData.Web.DatastoreView do
  use OpenData.Web, :view
  alias OpenData.Web.DatastoreView
  alias OpenData.Web.TopicView

  def render("index.json", %{datastores: datastores}) do
    %{data: render_many(datastores, DatastoreView, "datastore.json")}
  end

  def render("show.json", %{datastore: datastore}) do
    %{data: render_one(datastore, DatastoreView, "datastore.json")}
  end

  def render("datastore.json", %{datastore: datastore}) do
    %{id: datastore.id,
      hostname: datastore.hostname,
      username: datastore.username,
      password: datastore.password,
      database: datastore.database}
    |> include_topics(datastore)
  end

  defp include_topics(map, datastore) do
    if Ecto.assoc_loaded?(datastore.topics) do
      Map.put(map, :topics, render_many(datastore.topics, TopicView, "topic.json"))
    else
      IO.puts "NOT LOADED"
      map
    end
  end
end
