defmodule OpenData.Repo.Migrations.CreateOpenData.Ghostbuster.Topic do
  use Ecto.Migration

  def change do
    create table(:ghostbuster_topics) do
      add :datastore_id, :integer
      add :name, :string
      add :schema, :map

      timestamps()
    end

  end
end
