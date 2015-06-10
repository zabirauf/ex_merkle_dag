defmodule MerkleDAG.Link do
  @moduledoc """
  Link is a link between Nodes
  """

  alias MerkleDAG.Link, as: Link

  @type t :: %Link{name: String.t, size: number, hash: Multihash.t, node: Node.t}
  defstruct [:name, :size, :hash, :node]

end
