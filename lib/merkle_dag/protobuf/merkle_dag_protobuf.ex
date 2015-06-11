defmodule MerkleDAG.Protobuf do
  use Protobuf, from: Path.expand("./merkledag.proto", __DIR__)

  @type pbnode_type :: %MerkleDAG.Protobuf.PBNode{}
  @type pblink_type :: %MerkleDAG.Protobuf.PBLink{}
end
