defmodule OpenData.Repo.Migrations.CreateOpenData.Ghostbuster.Datastore do
  use Ecto.Migration

  def change do
    create table(:ghostbuster_datastores) do
      add :hostname, :string
      add :username, :string
      add :password, :string
      add :database, :string

      timestamps()
    end

  end
end
