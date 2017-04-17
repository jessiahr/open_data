defmodule OpenData.Web.DatastoreView do
  use OpenData.Web, :view
  alias OpenData.Web.DatastoreView

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
  end
end
