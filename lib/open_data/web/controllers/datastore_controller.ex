defmodule OpenData.Web.DatastoreController do
  use OpenData.Web, :controller

  alias OpenData.Ghostbuster
  alias OpenData.Ghostbuster.Datastore

  action_fallback OpenData.Web.FallbackController

  def index(conn, _params) do
    datastores = Ghostbuster.list_datastores()
    render(conn, "index.json", datastores: datastores)
  end

  def create(conn, %{"datastore" => datastore_params}) do
    with {:ok, %Datastore{} = datastore} <- Ghostbuster.create_datastore(datastore_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", datastore_path(conn, :show, datastore))
      |> render("show.json", datastore: datastore)
    end
  end

  # def show(conn, %{"id" => id, "model" => model}) do
  #   datastore = Ghostbuster.get_datastore_model(id, model)
  #   render(conn, "show.json", datastore: datastore)
  # end

  def show(conn, %{"id" => id}) do
    datastore = Ghostbuster.get_datastore!(id)
    render(conn, "show.json", datastore: datastore)
  end

  def update(conn, %{"id" => id, "datastore" => datastore_params}) do
    datastore = Ghostbuster.get_datastore!(id)

    with {:ok, %Datastore{} = datastore} <- Ghostbuster.update_datastore(datastore, datastore_params) do
      render(conn, "show.json", datastore: datastore)
    end
  end

  def delete(conn, %{"id" => id}) do
    datastore = Ghostbuster.get_datastore!(id)
    with {:ok, %Datastore{}} <- Ghostbuster.delete_datastore(datastore) do
      send_resp(conn, :no_content, "")
    end
  end
end
