defmodule MerkleDAG.DAG do
  alias MerkleDAG.Node, as: Node
  alias MerkleDAG.Link, as: Link
  alias MerkleDAG.Blocks.Key, as: Key
  alias MerkleDAG.DataStore, as: DataStore
  alias MerkleDAG.Blocks.Block, as: Block

  require Monad.Error
  import Monad.Error

  @type error_ret :: {:error, any}

  @doc"""
  Adds the `node` to the `datastore` and return `{:ok, {datastore, key}}` in case of success.
  In case of failure returns `{:error, reason}`
  """
  @spec add(DataStore.t, Node.t) :: {:ok, {DataStore.t, Key.t}} | error_ret
  def add(datastore, node) do
    node = Node.encode(node)
    block = %Block{data: node.encoded, multihash: Node.multihash(node)}
    key = Block.get_key(block)

    case DataStore.put(datastore, key, block) do
      {:ok, updated_datastore} -> {:ok, {updated_datastore, key}}
      error = {:error, _error} -> error
    end
  end

  @doc """
  Adds the `node` to the `datastore` and along with it recursively complete DAG under the `node`
  Returns `{:ok, datastore}` in case of success.
  Returns `{:error, reason}` in case of any failure
  """
  @spec add_recursive(DataStore.t, Node.t) :: {:ok, DataStore.t} | error_ret
  def add_recursive(datastore, node) do
    Monad.Error.p do
      add(datastore, node)
      |> (fn {datastore, _key} -> {:ok, datastore} end).()
      |> map_recursive_link(node.links, &add_recursive/2)
    end
  end

  @doc """
  Removes the `node` from the `datastore` and returns `{:ok, DataStore.t}` in case of success.
  In case of failure returns `{:error, reason}`
  """
  @spec remove(DataStore.t, Node.t) :: {:ok, DataStore.t} | error_ret
  def remove(datastore, node) do
    # OPTIMIZE: I don't thik there is need to do encoding again, only key should be enough
    node = Node.encode(node)
    block = %Block{data: node.encoded, multihash: Node.multihash(node)}
    key = Block.get_key(block)

    case DataStore.delete(datastore, key) do
      {:ok, updated_datastore} -> {:ok, updated_datastore}
      error = {:error, _error} -> error
    end
  end

  @doc """
  Removes the `node` from the `datastore` and along with it recursively remove nodes under the `node`
  Returns `{:ok, datastore}` in case of success.
  Returns `{:error, reason}` in case of any failure
  """
  @spec remove_recursive(DataStore.t, Node.t) :: {:ok, DataStore.t} | error_ret
  def remove_recursive(datastore, node) do
    Monad.Error.p do
      remove(datastore, node)
      |> map_recursive_link(node.links, &remove_recursive/2)
    end
  end

  @doc """
  Gets the `key`s value from the `datastore` and returns a node.
  Returns `{:ok, node}` if found else `{:error, :not_found}`.
  Returns `{:error, reason}` in case of any other failure
  """
  @spec get(DataStore.t, Key.t) :: {:ok, Node.t} | {:error, :not_found} | error_ret
  def get(datastore, key) do
    case DataStore.get(datastore, key) do
      {:ok, block} -> {:ok, Node.decode(block.data)}
      error = {:error, _error} -> error
    end
  end

  # TODO: See what precisely to return. What will be equivalent of NodeGetter
  @spec get_dag(DataStore.t, Node.t) :: {:ok, any} | error_ret
  def get_dag(datastore, node) do
    {:error, :not_implemented}
  end

  # TODO: See what precisely to return. What will be equivalent of NodeGetter
  @spec get_nodes(DataStore.t, [Key.t]) :: {:ok, any} | error_ret
  def get_nodes(datastore, keys) do
    {:error, :not_implemented}
  end

  @doc """
  Maps the `fun` on the links recursively to the datastore and at the end returns the updated datastore
  """
  # @spec map_recursive_link(DataStore.t, [], ((DataStore.t, Node.t) -> {:ok, DataStore.t | error_ret})) :: {:ok, DataStore.t}
  defp map_recursive_link(datastore, [], fun), do: {:ok, datastore}

  # @spec map_recursive_link(DataStore.t, [Link.t], ((DataStore.t, Node.t) -> {:ok, DataStore.t | error_ret})) :: {:ok, DataStore.t} | error_ret
  defp map_recursive_link(datastore, [%Link{node: nil} | links], fun) do
    map_recursive_link(datastore, links, fun)
  end

  defp map_recursive_link(datastore, [%Link{node: node}| links], fun) do
    case fun.(datastore, node) do
      {:ok, datastore} -> map_recursive_link(datastore, links, fun)
      error = {:error, _error} -> error
    end
  end
end
