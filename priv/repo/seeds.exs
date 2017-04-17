# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OpenData.Repo.insert!(%OpenData.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

datastore = OpenData.Repo.insert!(%OpenData.Ghostbuster.Datastore{hostname: "localhost", database: "open_data_test", username: "postgres", password: "postgres"})
schema = %{
      "name" => "gostbuster_table",
      "fields" => [
        %{
          "name" => "first_name",
          "type" => "string"
        },
        %{
          "name" => "last_name",
          "type" => "text"
        }
      ]
    }
OpenData.Ghostbuster.create_topic(%{name: "houses", schema: schema, datastore_id: datastore.id})
