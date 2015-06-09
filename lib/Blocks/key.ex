defmodule MerkleDAG.Blocks.Key do

  @type t :: String.t

  @spec base_encode_key(t) :: String.t
  def base_encode_key(key), do: base_encode key

  @spec base_decode_key(t) :: String.t
  def base_decode_key(key), do: base_decode key

  defp base_encode(str), do: Base.encode64 str

  defp base_decode!(str), do: Base.decode64! str

  defp base_decode(str), do: Base.decode64 str
end
