defmodule MerkleDAG.Protobuf.Util do
  @moduledoc """
  Contains the utility functions to help in converting Node to ProtoBuf Node and vice versa.
  Contains the utility functions to help in converting Link to ProtoBuf Link and vice versa
  """
  alias MerkleDAG.Node, as: Node
  alias MerkleDAG.Link, as: Link

  @type pbnode :: MerkleDAG.Protobuf.pbnode_type
  @type pblink :: MerkleDAG.Protobuf.pblink_type

  @doc """
  Converts the `node` to a ProtoBuf node
  """
  @spec to_pb_node(Node.t) :: pbnode
  def to_pb_node(node) do
    MerkleDAG.Protobuf.PBNode.new(
      Data: node.data,
      Links: Enum.map(node.links, &to_pb_link/1))
  end

  @doc """
  Converts to Node from the ProtoBuf Node
  """
  @spec from_pb_node(pbnode) :: Node.t
  def from_pb_node(%MerkleDAG.Protobuf.PBNode{Data: data, Links: pb_links}) do
    %Node{data: data, links: Enum.map(pb_links, &from_pb_link/1)}
  end

  @doc """
  Converts the `link` to ProtoBuf Link
  """
  @spec to_pb_link(Link.t) :: pblink
  def to_pb_link(link) do
    MerkleDAG.Protobuf.PBLink.new(Name: link.name, Tsize: link.size, Hash: link.hash)
  end

  @doc """
  Converts to Link from the ProtoBuf Link
  """
  @spec from_pb_link(pblink) :: Link.t
  def from_pb_link(%MerkleDAG.Protobuf.PBLink{Name: name, Tsize: size, Hash: hash}) do
    %Link{name: name, size: size, hash: hash}
  end
end
