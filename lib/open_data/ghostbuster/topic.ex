defmodule OpenData.Ghostbuster.Topic do
  use Ecto.Schema
  alias OpenData.Ghostbuster.Datastore
  alias OpenData.Repo
  import IEx
  schema "ghostbuster_topics" do
    field :name, :string
    field :schema, :map
    belongs_to :datastore, OpenData.Ghostbuster.Datastore


    timestamps()
  end

  def get_records(conn, topic) do
    IO.puts "SELECT * from \"public\".\"#{topic.name}\""
    {:ok, results} = Postgrex.query(conn, "SELECT * from \"public\".\"#{topic.name}\"", [])
    Enum.map(results.rows, fn(row) ->
      Enum.zip(results.columns, row)
      |> Enum.into(%{})
    end)
  end

  def create_table(conn, topic) do
    field_string = topic.schema
    |> Map.get("fields")
    |> Enum.map(fn(field) ->
      field_to_sql(field)
    end)
    |> Enum.join(", ")
    # name = Map.get(topic.schema, "name")
    # IO.puts "CREATE TABLE #{name} (#{field_string})"
    IO.inspect Postgrex.query(conn, "CREATE TABLE #{topic.name} (id serial primary key, #{field_string})", [])
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

  def insert_record(conn, topic, data) do
    field_list = data
    |> Map.to_list

    fields = field_list
    |> Enum.map(fn(field) -> "\"#{elem(field, 0)}\"" end)
    |> Enum.join(", ")

    values = field_list
    |> Enum.map(fn(field) -> "'#{elem(field, 1)}'" end)
    |> Enum.join(", ")
    IO.puts "INSERT INTO \"public\".\"#{topic.name}\"(#{fields}) VALUES(#{values})"
    {:ok, results} = Postgrex.query(conn, "INSERT INTO \"public\".\"#{topic.name}\"(#{fields}) VALUES(#{values}) RETURNING *", [])
    row = Enum.map(results.rows, fn(row) ->
      Enum.zip(results.columns, row)
      |> Enum.into(%{})
    end)
    |> List.first
    {:ok, row}
  end
end
