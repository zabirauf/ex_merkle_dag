defmodule MerkleDAG.NodeStat do
  @moduledoc """
  NodeStat represents different statistics regarding a node
  """

  alias MerkleDAG.NodeStat, as: NodeStat

  @type t :: %NodeStat{num_links: pos_integer, block_size: pos_integer, links_size: pos_integer, data_size: pos_integer, cumulative_size: pos_integer}
  defstruct num_links: 0, block_size: 0, links_size: 0, data_size: 0, cumulative_size: 0

end
