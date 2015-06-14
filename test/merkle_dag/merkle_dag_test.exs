defmodule MerkleDagTest do
  use ExUnit.Case

  alias MerkleDAG.DataStore.Memory, as: MemoryStore
  alias MerkleDAG.DAG, as: DAG
  alias MerkleDAG.Node, as: Node
  alias MerkleDAG.Link, as: Link

  test "Add a node to datastore" do
    assert create_datastore
    |> add(%Node{data: <<1>>, links: []})
    |> add(%Node{data: <<2>>, links: []})
  end

  test "Get a node from datastore" do
    node = %Node{data: <<1>>, links: []}
    assert {:ok, {ds, key}} = DAG.add(create_datastore(), node)
    assert {:ok, ^node} = DAG.get(ds, key)
  end

  test "Remove a node from datastore" do
    node = %Node{data: <<1>>, links: []}
    ds = create_datastore |> add(node)
    assert {:ok, ds} = DAG.remove(ds, node)

    # As we added only one node and removed it so the updated
    # datastore should look like a newly created datastore
    assert ^ds = create_datastore
  end

  test "Add a node and all its links to DAG" do
    node_link1 = %Node{data: <<1>>, links: []}
    node_link2 = %Node{data: <<2>>, links: []}
    link1 = %Link{name: "link1", node: node_link1}
    link2 = %Link{name: "link2", node: node_link2}
    node = %Node{data: <<3>>, links: [link1, link2]}

    assert {:ok, ds} = create_datastore()
    |> DAG.add_recursive(node)
  end

  test "Remove a node and all its links from DAG" do
    node_link1 = %Node{data: <<1>>, links: []}
    node_link2 = %Node{data: <<2>>, links: []}
    link1 = %Link{name: "link1", node: node_link1}
    link2 = %Link{name: "link2", node: node_link2}
    node = %Node{data: <<3>>, links: [link1, link2]}

    assert {:ok, ds} = create_datastore()
    |> DAG.add_recursive(node)

    assert {:ok, ds} = DAG.remove_recursive(ds, node)

    assert ^ds = create_datastore
  end

  test "Remove patial nodes recursively from DAG" do
    # This is how the node chain looks like
    # ROOT (node) --- link1 --> (node_link1) --- link1_link1 --> (node_link1_link1)
    # We add from (node) and then recursively delete from (node_link1)

    node_link1_link1 = %Node{data: <<1>>, links: []}
    link1_link1 = %Link{name: "link1_link1", node: node_link1_link1}

    node_link1 = %Node{data: <<2>>, links: [link1_link1]}
    link1 = %Link{name: "link1", node: node_link1}

    node = %Node{data: <<3>>, links: [link1]}

    assert {:ok, ds} = create_datastore()
    |> DAG.add_recursive(node)

    assert {:ok, updated_ds} = DAG.remove_recursive(ds, node_link1)

    # As the datastore should not be empty, it should have (node) so
    # it should not match with an empty datastore
    refute ^updated_ds = create_datastore

    # It also should not match the datastore before removing
    refute ^updated_ds = ds

  end

  defp create_datastore(), do: MemoryStore.create

  defp add(datastore, node) do
    {:ok, {ds, _key}} = DAG.add datastore, node
    ds
  end
end
