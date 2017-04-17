defmodule OpenData.GhostbusterTest do
  use OpenData.DataCase

  alias OpenData.Ghostbuster
  alias OpenData.Ghostbuster.Datastore

  @create_attrs %{database: "some database", hostname: "some hostname", password: "some password", username: "some username"}
  @update_attrs %{database: "some updated database", hostname: "some updated hostname", password: "some updated password", username: "some updated username"}
  @invalid_attrs %{database: nil, hostname: nil, password: nil, username: nil}

  def fixture(:datastore, attrs \\ @create_attrs) do
    {:ok, datastore} = Ghostbuster.create_datastore(attrs)
    datastore
  end

  test "list_datastores/1 returns all datastores" do
    datastore = fixture(:datastore)
    assert Ghostbuster.list_datastores() == [datastore]
  end

  test "get_datastore! returns the datastore with given id" do
    datastore = fixture(:datastore)
    assert Ghostbuster.get_datastore!(datastore.id) == datastore
  end

  test "create_datastore/1 with valid data creates a datastore" do
    assert {:ok, %Datastore{} = datastore} = Ghostbuster.create_datastore(@create_attrs)
    assert datastore.database == "some database"
    assert datastore.hostname == "some hostname"
    assert datastore.password == "some password"
    assert datastore.username == "some username"
  end

  test "create_datastore/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Ghostbuster.create_datastore(@invalid_attrs)
  end

  test "update_datastore/2 with valid data updates the datastore" do
    datastore = fixture(:datastore)
    assert {:ok, datastore} = Ghostbuster.update_datastore(datastore, @update_attrs)
    assert %Datastore{} = datastore
    assert datastore.database == "some updated database"
    assert datastore.hostname == "some updated hostname"
    assert datastore.password == "some updated password"
    assert datastore.username == "some updated username"
  end

  test "update_datastore/2 with invalid data returns error changeset" do
    datastore = fixture(:datastore)
    assert {:error, %Ecto.Changeset{}} = Ghostbuster.update_datastore(datastore, @invalid_attrs)
    assert datastore == Ghostbuster.get_datastore!(datastore.id)
  end

  test "delete_datastore/1 deletes the datastore" do
    datastore = fixture(:datastore)
    assert {:ok, %Datastore{}} = Ghostbuster.delete_datastore(datastore)
    assert_raise Ecto.NoResultsError, fn -> Ghostbuster.get_datastore!(datastore.id) end
  end

  test "change_datastore/1 returns a datastore changeset" do
    datastore = fixture(:datastore)
    assert %Ecto.Changeset{} = Ghostbuster.change_datastore(datastore)
  end

end
