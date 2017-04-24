defmodule OpenData.Repo.Migrations.CreateOpenData.Ghostbuster.Topic do
  use Ecto.Migration

  def change do
    create table(:ghostbuster_topics) do
      add :datastore_id, references(:ghostbuster_datastores)
      add :name, :string
      add :schema, :map

      timestamps()
    end
    create unique_index(:ghostbuster_topics, [:name, :datastore_id])

  end
end
