defmodule MerkleDAG.Blocks.Block do

  alias MerkleDAG.Blocks.Block, as: Block

  @type multihash :: binary

  @type t :: %Block{multihash: multihash, data: binary}
  defstruct [:multihash, :data]

  @default_hash_algorithm :sha2_256

  @spec create(binary) :: t
  def create(data), do: %Block{
      multihash: Multihash.Util.sum(data, @default_hash_algorithm),
      data: data
    }

  @spec get_key(t) :: multihash
  def get_key(block), do: nil
end
