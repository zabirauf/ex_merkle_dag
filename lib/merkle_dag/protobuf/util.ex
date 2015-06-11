defmodule MerkleDAG.Protobuf.Util do

  alias MerkleDAG.Node, as: Node
  alias MerkleDAG.Link, as: Link

  @type pbnode :: MerkleDAG.Protobuf.pbnode_type
  @type pblink :: MerkleDAG.Protobuf.pblink_type

  @spec to_pb_node(Node.t) :: pbnode
  def to_pb_node(node) do
    MerkleDAG.Protobuf.PBNode.new(
      Data: node.data,
      Links: Enum.map(node.links, &to_pb_link/1))
  end

  @spec from_pb_node(pbnode) :: Node.t
  def from_pb_node(%MerkleDAG.Protobuf.PBNode{Data: data, Links: pb_links}) do
    links = from_pb_link(pb_links)
    %Node{data: data, links: links}
  end

  @spec to_pb_link(Link.t) :: pblink
  def to_pb_link(link) do
    MerkleDAG.Protobuf.PBLink.new(Name: link.name, Tsize: link.size, Hash: link.hash)
  end

  @spec from_pb_link(pblink) :: Link.t
  def from_pb_link(%MerkleDAG.Protobuf.PBLink{Name: name, Tsize: size, Hash: hash}) do
    %Link{name: name, size: size, hash: hash}
  end
end
