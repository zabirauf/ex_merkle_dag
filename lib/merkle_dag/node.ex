defmodule MerkleDAG.Node do
  alias MerkleDAG.Node, as: Node
  alias MerkleDAG.Link, as: Link
  alias MerkleDAG.NodeStat, as: NodeStat
  alias MerkleDAG.Blocks.Key, as: Key
  alias MerkleDAG.Protobuf, as: Protobuf
  alias MerkleDAG.Protobuf.Util, as: ProtobufUtil

  @type t :: %Node{links: [Link.t], data: binary, encoded: binary, cached: Multihash.t}
  defstruct [:links, :data, :encoded, :cached]

  @default_hashing_algorithm :sha2_256

  @doc"""
  Size returns the total size of the data addressed by the node.
  It also includes the size of all the link references.
  """
  @spec size(Node.t) :: number
  def size(node) do
    encoded_size = encode(node).encoded |> byte_size
    links_size = Enum.reduce node.links, 0, fn(link, acc) ->
      acc + link.size
    end

    encoded_size + links_size
  end

  @doc"""
  Returns the statistic on the `node`
  """
  @spec node_stat(Node.t) :: NodeStat.t
  def node_stat(node) do
    encoded_node = encode(node)
    size = size(node)
    encoded_size = byte_size(encoded_node.encoded)
    %NodeStat{
      num_links: length(node.links),
      block_size: encoded_size,
      links_size: encoded_size - byte_size(node.data),
      data_size: byte_size(node.data),
      cumulative_size: size
    }
  end

  @doc"""
  Hashes the encoded data of this `node` including the links
  """
  @spec multihash(Node.t) :: Multihash.t
  def multihash(node), do: encode(node).cached

  @doc"""
  Creates a key using the multihash of the `node`
  """
  @spec get_key(Node.t) :: Key.t
  def get_key(node) do
    multihash(node)
  end

  @doc"""
  Creates a link to the given `node`
  """
  @spec make_link(Node.t) :: Link.t
  def make_link(node), do: %Link{size: size(node), hash: multihash(node)}

  @doc"""
  Add a link with the `name` of `other_node` to `node`.
  The link will contain the `other_node`
  """
  @spec add_node_link(Node.t, Node.t, String.t | nil) :: Node.t
  def add_node_link(node, other_node, name \\ nil) do
    link =
      other_node
    |> make_link
    |> Map.put(:name, name)
    |> Map.put(:node, other_node)

    Map.update!(node, :links, &([link | &1]))
  end

  @doc"""
  Add a link with the `name` of `other_node` to `node`.
  It is only reference so link would not contain `other_node`
  """
  @spec add_node_link_clean(Node.t, Node.t, String.t | nil) :: Node.t
  def add_node_link_clean(node, other_node, name \\ nil) do
    link =
      other_node
    |> make_link
    |> Map.put(:name, name)

    Map.update!(node, :links, &([link | &1]))
  end

  @doc"""
  Updates the `node` link with `name` to instead link to `other_node`
  """
  @spec update_node_with_link(Node.t, Node.t, String.t) :: Node.t
  def update_node_with_link(node, other_node, name) do
    node
    |> remove_node_link(name)
    |> add_node_link(other_node, name)
  end

  @doc """
  Removes the link with `name` from the `node`
  """
  @spec remove_node_link(Node.t, String.t) :: Node.t
  def remove_node_link(node, name) do
    case Enum.filter node.links, &(&1.name == name) do
      [_ | links] -> Map.put node, :links, links
      [] -> node
    end
  end

  @doc """
  Returns the link with `name` in the `node`
  """
  @spec get_node_link(Node.t, String.t) :: Link.t | :not_found
  def get_node_link(node, name) do
    case Enum.filter node.links, &(&1.name == name) do
      [link | _] -> link
      [] -> :not_found
    end
  end

  @doc """
  Encodes the `node` and add the encoded binary to `node.encoded`.
  Will also update the hash of the node in `node.cached`
  """
  @spec encode(Node.t) :: Node.t
  def encode(node) do
    node = Map.put node, :encoded, marshal(node)
    Map.put node, :cached, Multihash.Util.sum(node.encoded, @default_hashing_algorithm)
  end

  @doc """
  Decodes the `binary` to node. The links will be sorted by name
  """
  @spec decode(binary) :: Node.t
  def decode(node), do: unmarshal(node)

  @doc false
  @spec marshal(Node.t) :: binary
  def marshal(node) do
    node
    |> get_link_sorted_node
    |> ProtobufUtil.to_pb_node
    |> Protobuf.PBNode.encode
  end

  @doc false
  @spec unmarshal(binary) :: Node.t
  def unmarshal(node_binary) do
    node_binary
    |> Protobuf.PBNode.decode
    |> ProtobufUtil.from_pb_node
    |> get_link_sorted_node
  end

  @doc false
  @spec get_link_sorted_node(Node.t) :: Node.t
  def get_link_sorted_node(node) do
    node.links
    |> Enum.sort(&(&1.name <= &2.name))
    |> (&(Map.put(node, :links, &1))).()
  end
end
