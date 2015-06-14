defmodule MerkleDAG.Blocks.Block do
  @moduledoc """
  Blocks are the lowest level of entity that is actually stored into the DAG
  It contains the binary data and the multihash of it
  """

  alias MerkleDAG.Blocks.Key, as: Key
  alias MerkleDAG.Blocks.Block, as: Block

  @type multihash :: Multihash.t

  @type t :: %Block{data: binary, multihash: multihash}
  defstruct data: nil, multihash: nil

  @default_hash_algorithm :sha2_256

  @doc"""
  Create the block from the `data` and computing its multihash
  Uses SHA256 to compute the multihash
  """
  @spec create(binary) :: t
  def create(data), do: %Block{
      multihash: Multihash.Util.sum(data, @default_hash_algorithm),
      data: data
    }

  @doc"""
  Gets the key of the block i.e. the multihash
  """
  @spec get_key(t) :: Key.t
  def get_key(block), do: Key.key(block.multihash)
end
