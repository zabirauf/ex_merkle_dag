defmodule MerkleDAG.Node do

  alias MerkleDAG.Node, as: Node
  alias MerkleDAG.Link, as: Link
  alias MerkleDAG.NodeState, as: NodeStat
  alias MerkleDAG.Blocks.Key, as: Key


  @type t :: %Node{links: [Link.t], data: binary, encoded: binary, cached: Multihash.t}
  defstruct [:links, :data, :encoded, :cached]

  @spec size(Node.t) :: number
  def size(node) do
    nil
  end

  @spec node_stat(Node.t) :: NodeStat.t
  def node_stat(node) do
    nil
  end

  @spec multihash(Node.t) :: Multihash.t
  def multihash(node) do
    nil
  end

  @spec get_key(Node.t) :: Key.t
  def get_key(node) do
    nil
  end

  @spec make_link(Node.t, Link.t) :: Link.t
  def make_link(node, link) do
    nil
  end

  @spec add_node_link(Node.t, Link.t, String.t | nil) :: Node.t
  def add_node_link(node, link, name \\ nil) do
    nil
  end

  @spec update_node_with_link(Node.t, Link.t) :: Node.t
  def update_node_with_link(node, link) do
    nil
  end

  @spec remove_node_link(Node.t, String.t) :: Node.t
  def remove_node_link(node, name) do
    nil
  end

  @spec get_node_link(Node.t, String.t) :: Node.t
  def get_node_link(node, name) do
    nil
  end

end
