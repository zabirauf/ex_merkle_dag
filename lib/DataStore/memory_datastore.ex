defimpl MerkleDAG.DataStore, for: HashDict do

  def put(datastore, key, value), do: Dict.put(datastore, key, value)

  def get(datastore, key) do
    case Dict.get(datastore, key, nil) do
      nil -> {:error, "Invalid key"}
      value -> {:ok, value}
    end
  end

  def has_key?(datastore, key), do: Dict.has_key?(datastore, key)

  def delete(datastore, key), do: Dict.delete(datastore, key)

  def query(datastore, query), do: nil
end

defmodule MerkleDAG.DataStore.Memory do
  def create(), do: %HashDict{}
end
