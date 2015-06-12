defmodule MerkleDAG.Test.Node do
  use ExUnit.Case

  require Logger
  alias MerkleDAG.Node, as: Node
  alias MerkleDAG.Link, as: Link

  test "the encoding and decoding of node" do
    node = create_sample_node

    node_with_encoding = Node.encode(node)
    decoded_node = Node.decode(node_with_encoding.encoded)

    assert node == decoded_node
  end

  test "the mulihash of node" do
    node = create_sample_node
    multihash = Node.multihash(node)
    assert true = is_binary(multihash)
    assert byte_size(multihash) == 34
  end

  test "create link to the node" do
    node = create_sample_node
    link = Node.make_link(node)

    assert link.hash == Node.multihash(node)
  end

  test "add link to another node" do
    node = create_sample_node |> Map.put(:links, [])
    node_to_link_to = %Node{links: [], data: << 4,5,6 >>}

    updated_node = Node.add_node_link(node, node_to_link_to)
    assert updated_node.data == node.data
    assert [link|[]] = updated_node.links
    assert link.node.data == node_to_link_to.data
    assert link.hash == Node.multihash(node_to_link_to)
  end

  test "get link from a node" do
    node = %Node{links: [
                    %Link{name: "link1", hash: <<1>>},
                    %Link{name: "link2", hash: <<2>>},
                    %Link{name: "link3", hash: <<3>>}],
                 data: << 1,2,3 >> }

    link_to_find = "link2"
    link = Node.get_node_link(node, link_to_find)
    assert link.name == link_to_find
    assert link.hash == <<2>>
  end

  test "get link from a node with a duplicate link" do
    node = %Node{links: [
                    %Link{name: "link1", hash: <<1>>},
                    %Link{name: "link2", hash: <<2>>},
                    %Link{name: "link2", hash: <<3>>}],
                 data: << 1,2,3 >> }

    link_to_find = "link2"
    link = Node.get_node_link(node, link_to_find)
    assert link.name == link_to_find
    assert link.hash == <<2>>
  end

  test "remove a link from the node" do
    node = create_sample_node
    updated_node = Node.remove_node_link(node, "link1")

    assert [] = updated_node.links
  end

  test "update a node with link" do
    node = %Node{links: [
                    %Link{name: "link1", node: %Node{links: [], data: << 4,5,6 >>}}
                  ], data: << 1,2,3 >>}
    new_node_to_link_to = %Node{links: [], data: << 7,8,9 >>}

    updated_node = Node.update_node_with_link(node, new_node_to_link_to, "link1")

    assert [link | []] = updated_node.links
    assert link.node.data == new_node_to_link_to.data
  end

  test "update a node with the link to update does not exist" do
    node = %Node{links: [], data: << 1,2,3 >>}
    new_node_to_link_to = %Node{links: [], data: << 7,8,9 >>}

    updated_node = Node.update_node_with_link(node, new_node_to_link_to, "link1")

    assert [link | []] = updated_node.links
    assert link.node.data == new_node_to_link_to.data
  end

  defp create_sample_node() do
    link = %Link{name: "link1", size: 0}
    %Node{links: [link], data: << 1,2,3 >> }
  end
end
