defmodule MerkleDAG.Node do

  alias MerkleDAG.Node, as: Node
  alias MerkleDAG.Link, as: Link
  alias MerkleDAG.NodeState, as: NodeStat
  alias MerkleDAG.Blocks.Key, as: Key
  alias MerkleDAG.Protobuf, as: Protobuf
  alias MerkleDAG.Protobuf.Util, as: ProtobufUtil

  @type t :: %Node{links: [Link.t], data: binary, encoded: binary, cached: Multihash.t}
  defstruct [:links, :data, :encoded, :cached]

  @default_hashing_algorithm :sha2_256

  @spec size(Node.t) :: number
  def size(node) do
    encoded_size = encode(node).encoded |> byte_size
    links_size = Enum.reduce(node.links, 0, fn(link, acc) -> acc + link.size end)

    encoded_size + links_size
  end

  @spec node_stat(Node.t) :: NodeStat.t
  def node_stat(node) do
    nil
  end

  @spec multihash(Node.t) :: Multihash.t
  def multihash(node), do: encode(node).cached

  @spec get_key(Node.t) :: Key.t
  def get_key(node) do
    nil
  end

  @spec make_link(Node.t) :: Link.t
  def make_link(node), do: %Link{size: size(node), hash: multihash(node)}

  @spec add_node_link(Node.t, Node.t, String.t | nil) :: Node.t
  def add_node_link(node, other_node, name \\ nil) do
    link = make_link(other_node) |> Map.put(:name, name) |> Map.put(:node, other_node)
    Map.update!(node, :links, &([link | &1]))
  end

  @spec add_node_link_clean(Node.t, Node.t, String.t | nil) :: Node.t
  def add_node_link_clean(node, other_node, name \\ nil) do
    link = make_link(other_node) |> Map.put(:name, name)
    Map.update!(node, :links, &([link | &1]))
  end

  @spec update_node_with_link(Node.t, Node.t, String.t) :: Node.t
  def update_node_with_link(node, other_node, name) do
    remove_node_link(node, name) |> add_node_link(other_node, name)
  end

  @spec remove_node_link(Node.t, String.t) :: Node.t
  def remove_node_link(node, name) do
    case Enum.filter(node.links, &(&1.name == name)) do
      [_ | links] -> Map.put(node, :links, links)
      [] -> node
    end
  end

  @spec get_node_link(Node.t, String.t) :: Link.t | :not_found
  def get_node_link(node, name) do
    case Enum.filter(node.links, &(&1.name == name)) do
      [link | _] -> link
      [] -> :not_found
    end
  end

  @spec encode(Node.t) :: Node.t
  def encode(node) do
    node = Map.put(node, :encoded, marshal(node))
    Map.put(node, :cached, Multihash.Util.sum(node.encoded, @default_hashing_algorithm))
  end

  @spec decode(binary) :: Node.t
  def decode(node), do: unmarshal(node)

  @spec marshal(Node.t) :: binary
  def marshal(node), do:
  get_link_sorted_node(node) |> ProtobufUtil.to_pb_node |> Protobuf.PBNode.encode

  @spec unmarshal(binary) :: Node.t
  def unmarshal(node_binary), do:
  Protobuf.PBNode.decode(node_binary) |> ProtobufUtil.from_pb_node |> get_link_sorted_node

  @spec get_link_sorted_node(Node.t) :: Node.t
  def get_link_sorted_node(node), do:
  Enum.sort(node.links, &(&1.name <= &2.name)) |> (&(Map.put(node, :links, &1))).()
end
