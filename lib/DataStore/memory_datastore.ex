defimpl MerkleDAG.DataStore, for: HashDict do

  def put(datastore, key, value), do: {:ok, Dict.put(datastore, key, value)}

  def get(datastore, key) do
    case Dict.get(datastore, key, nil) do
      nil -> {:error, :not_found}
      value -> {:ok, value}
    end
  end

  def has_key?(datastore, key), do: Dict.has_key?(datastore, key)

  def delete(datastore, key), do: {:ok, Dict.delete(datastore, key)}

  def query(datastore, query), do: {:error, :not_implemented}

end

defmodule MerkleDAG.DataStore.Memory do
  def create(), do: %HashDict{}
end
