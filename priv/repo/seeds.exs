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

OpenData.Repo.insert!(%OpenData.Ghostbuster.Datastore{hostname: "localhost", database: "testdb1", username: "postgres", password: "postgres"})
