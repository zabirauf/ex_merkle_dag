defmodule MerkleDAG.Blocks.Key do

  @type t :: String.t

  @default_prefix 128

  @doc """
  Encodes the key to Base 58 binary

  ## Examples
      iex> MerkleDAG.Blocks.Key.base_encode_key "/Comedy/MontyPython/Actor:Jeenice"
      "KxoasVXrTvQoR7ZYaiQMGHzZtNaEzTbQ1N84xTVhN6AfkmoyUMRT"
  """
  @spec base_encode_key(t) :: binary
  def base_encode_key(key), do: base_encode key

  @doc """
  Decodes the Base 58 encoded binary

  ## Examples
      iex> MerkleDAG.Blocks.Key.base_decode_key "KxoasVXrTvQoR7ZYaiQMGHzZtNaEzTbQ1N84xTVhN6AfkmoyUMRT"
      "/Comedy/MontyPython/Actor:Jeenice"
  """
  @spec base_decode_key(binary) :: t
  def base_decode_key(key), do: base_decode key

  @spec base_encode(String.t) :: binary
  defp base_encode(str), do: Base58Check.encode58check(@default_prefix, str)

  @spec base_decode(binary) :: String.t
  defp base_decode(str) do
    {_prefix, payload} = Base58Check.decode58check str
    payload
  end
end
