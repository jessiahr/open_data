defmodule OpenData.Ghostbuster do
  @moduledoc """
  The boundary for the Ghostbuster system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias OpenData.Repo
import IEx
  alias OpenData.Ghostbuster.Datastore

  @doc """
  Returns the list of datastores.

  ## Examples

      iex> list_datastores()
      [%Datastore{}, ...]

  """
  def list_datastores do
    Repo.all(Datastore) |> Repo.preload(:topics)
  end

  @doc """
  Gets a single datastore.

  Raises `Ecto.NoResultsError` if the Datastore does not exist.

  ## Examples

      iex> get_datastore!(123)
      %Datastore{}

      iex> get_datastore!(456)
      ** (Ecto.NoResultsError)

  """
  def get_datastore!(id), do: Repo.get!(Datastore, id)

  # def get_datastore_model(id, model) do
  #   datastore = Repo.get!(Datastore, id)
  #   {:ok, conn} = Datastore.start_worker(datastore)
  #   results = Postgrex.query(conn, "SELECT * from \"public\".\"#{model}\"", [])
  #   Datastore.stop_worker(conn)
  #   results
  #  end

  @doc """
  Creates a datastore.

  ## Examples

      iex> create_datastore(%{field: value})
      {:ok, %Datastore{}}

      iex> create_datastore(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_datastore(attrs \\ %{}) do
    %Datastore{}
    |> datastore_changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Updates a datastore.

  ## Examples

      iex> update_datastore(datastore, %{field: new_value})
      {:ok, %Datastore{}}

      iex> update_datastore(datastore, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_datastore(%Datastore{} = datastore, attrs) do
    datastore
    |> datastore_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Datastore.

  ## Examples

      iex> delete_datastore(datastore)
      {:ok, %Datastore{}}

      iex> delete_datastore(datastore)
      {:error, %Ecto.Changeset{}}

  """
  def delete_datastore(%Datastore{} = datastore) do
    Repo.delete(datastore)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking datastore changes.

  ## Examples

      iex> change_datastore(datastore)
      %Ecto.Changeset{source: %Datastore{}}

  """
  def change_datastore(%Datastore{} = datastore) do
    datastore_changeset(datastore, %{})
  end

  defp datastore_changeset(%Datastore{} = datastore, attrs) do
    datastore
    |> cast(attrs, [:hostname, :username, :password, :database])
    |> validate_required([:hostname, :username, :password, :database])
  end

  alias OpenData.Ghostbuster.Topic

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics(params) do
    case params do
      %{"datastore_id" => datastore_id} ->
        Repo.all from t in Topic,
          where: t.datastore_id == ^datastore_id
    end
  end

  def list_topic_records(datastore_id, topic_id) do
    datastore = Repo.get!(Datastore, datastore_id)
    topic = Repo.get!(Topic, topic_id)
      {:ok, conn} = Datastore.start_worker(datastore)
      rows = Topic.get_records(conn, topic)
      Datastore.stop_worker(conn)
      rows
  end

  def create_topic_record(topic_id, record_body) do
    # datastore = Repo.get!(Datastore, datastore_id)
    topic = Repo.get!(Topic, topic_id) |> Repo.preload(:datastore)
    {:ok, conn} = Datastore.start_worker(topic.datastore)
    row = Topic.insert_record(conn, topic, record_body)
    Datastore.stop_worker(conn)
    row
  end
  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id), do: Repo.get!(Topic, id)

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(attrs \\ %{}) do
    {:ok, topic} = %Topic{}
    |> topic_changeset(attrs)
    |> Repo.insert()
  end

  def create_topic_tables(topic) do
    datastore =  Repo.get!(Datastore, topic.datastore_id)
    {:ok, conn} = Datastore.start_worker(datastore)
    result = Topic.create_table(conn, topic)
    Datastore.stop_worker(conn)
    result
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> topic_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{source: %Topic{}}

  """
  def change_topic(%Topic{} = topic) do
    topic_changeset(topic, %{})
  end

  defp topic_changeset(%Topic{} = topic, attrs) do
    topic
    |> cast(attrs, [:datastore_id, :name, :schema])
    |> foreign_key_constraint(:datastore_id)
    |> validate_required([:datastore_id, :name, :schema])
    |> unique_constraint(:name_datastore_id)
  end
end
