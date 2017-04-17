defmodule OpenData.Ghostbuster.Datastore do
  use Ecto.Schema
import IEx
  schema "ghostbuster_datastores" do
    field :database, :string
    field :hostname, :string
    field :password, :string
    field :username, :string

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

  def create_table(conn, schema) do
    field_string = schema
    |> Map.get("fields")
    |> Enum.map(fn(field) ->
      field_to_sql(field)
    end)
    |> Enum.join(", ")
    name = Map.get(schema, "model")
    # IO.puts "CREATE TABLE #{name} (#{field_string})"
    Postgrex.query(conn, "CREATE TABLE #{name} (#{field_string})", [])
  end

  def field_to_sql(field) do
     type = case Map.get(field, "type") do
      "string" ->
        "character varying(255)"
      "text" ->
        "text"
      "boolean" ->
        "boolean DEFAULT false NOT NULL"
    end
    Map.get(field, "name") <> " " <> type

  end
end
