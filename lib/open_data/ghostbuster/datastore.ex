defmodule OpenData.Ghostbuster.Datastore do
  use Ecto.Schema
import IEx
  schema "ghostbuster_datastores" do
    field :database, :string
    field :hostname, :string
    field :password, :string
    field :username, :string
    has_many :topics, OpenData.Ghostbuster.Topic, on_delete: :delete_all

    timestamps()
  end

  def start_worker(datastore) do
    Postgrex.start_link(
      hostname: datastore.hostname,
      username: datastore.username,
      password: datastore.password,
      database: datastore.database
    )
  end

  def stop_worker(conn) do
    Process.unlink(conn)
    Process.exit(conn, :kill)
  end

end
