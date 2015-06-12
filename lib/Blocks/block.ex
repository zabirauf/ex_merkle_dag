defmodule MerkleDAG.Blocks.Block do
  alias MerkleDAG.Blocks.Key, as: Key
  alias MerkleDAG.Blocks.Block, as: Block

  @type multihash :: binary

  @type t :: %Block{data: binary, multihash: multihash}
  defstruct data: nil, multihash: nil

  @default_hash_algorithm :sha2_256

  @spec create(binary) :: t
  def create(data), do: %Block{
      multihash: Multihash.Util.sum(data, @default_hash_algorithm),
      data: data
    }

  @spec get_key(t) :: Key.t
  def get_key(block), do: Key.key(block.multihash)
end
