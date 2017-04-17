defmodule OpenData.Ghostbuster do
  @moduledoc """
  The boundary for the Ghostbuster system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias OpenData.Repo

  alias OpenData.Ghostbuster.Datastore

  @doc """
  Returns the list of datastores.

  ## Examples

      iex> list_datastores()
      [%Datastore{}, ...]

  """
  def list_datastores do
    Repo.all(Datastore)
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

  def get_datastore_model(id, model) do
    datastore = Repo.get!(Datastore, id)
    {:ok, conn} = Datastore.start_worker(datastore)
    results = Postgrex.query(conn, "SELECT * from \"public\".\"#{model}\"", [])
    Datastore.stop_worker(conn)
    results
   end

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
    |> format_datastore(Map.get(attrs, "schema"))
  end

  def format_datastore({:ok, datastore}, schema) do
    {:ok, conn} = Datastore.start_worker(datastore)
    Datastore.create_table(conn, schema)
    Datastore.stop_worker(conn)
    {:ok, datastore}
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
end
