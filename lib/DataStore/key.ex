defmodule MerkleDAG.DataStore.Key do
  # @type Key::string

  @namespace_separator "/"

  defmodule Namespace do
    def type(namespace) do
      parts = String.split(namespace, ":")
      if length(parts) < 2 do
        ""
      else
        Enum.take(parts, length(parts)-1) |> Enum.join(":")
      end
    end

    def value(namespace) do
      ns = String.split(namespace, ":")
      Enum.at(ns, length(ns)-1)
    end
  end
  alias MerkleDAG.DataStore.Key.Namespace, as: Namespace

  def create_key_from_namespaces(namespaces), do: Enum.join([""|namespaces], @namespace_separator)

  def equal(key1, key2), do: key1 === key2

  def to_bytes(key), do: <<key>>

  def less?(key_lhs, key_rhs) when is_binary(key_lhs) and is_binary(key_rhs), do:
  less?(namespaces_from_key(key_lhs), namespaces_from_key(key_rhs))

  def less?([], [_ns_rhs|_]), do: true
  def less?([_ns_lhs|_], []), do: false
  def less?([ns_lhs|_], [ns_rhs|_]) when ns_lhs < ns_rhs, do: true
  def less?([ns_lhs|_], [ns_rhs|_]) when ns_rhs < ns_lhs, do: false
  def less?([_|kn_lhs], [_|kn_rhs]), do: less?(kn_lhs, kn_rhs)

  @doc ~S"""
  Returns the list of namespaces in this key

  ## Examples

      iex> MerkleDAG.DataStore.Key.namespaces_from_key("/Comedy/MontyPython/Actor:JohnCleese")
      ["Comedy", "MontyPython", "Actor:JohnCleese"]
  """
  def namespaces_from_key(key), do: String.split(key, @namespace_separator, trim: true)

  @doc ~S"""
  Reverses the namespaces in the key

  ## Examples

      iex> MerkleDAG.DataStore.Key.reverse("/Comedy/MontyPython/Actor:JohnCleese")
      "/Actor:JohnCleese/MontyPython/Comedy"
  """
  def reverse(key), do: namespaces_from_key(key) |> Enum.reverse |> create_key_from_namespaces

  @doc ~S"""
  Returns the base namespace of this key

  ## Examples

      iex> MerkleDAG.DataStore.Key.base_namespace("/Comedy/MontyPython/Actor:JohnCleese")
      "Actor:JohnCleese"
  """
  def base_namespace(key) do
    [ns] = Enum.take(namespaces_from_key(key), -1)
    ns
  end

  @doc ~S"""
  Returns the type of the key i.e. the type of the last namespace

  ## Examples

      iex> MerkleDAG.DataStore.Key.type("/Comedy/MontyPython/Actor:JohnCleese")
      "Actor"
  """
  def type(key), do: base_namespace(key) |> Namespace.type

  @doc ~S"""
  Returns the name of the key i.e. the value of the last namespace

  ## Examples

      iex> MerkleDAG.DataStore.Key.name("/Comedy/MontyPython/Actor:JohnCleese")
      "JohnCleese"
  """
  def name(key), do: base_namespace(key) |> Namespace.value

  @doc ~S"""
  Creates an instance of the key with the provided instance value

  ## Examples

      iex> MerkleDAG.DataStore.Key.create_instance("/Comedy/MontyPython/Actor", "JohnCleese")
      "/Comedy/MontyPython/Actor:JohnCleese"
  """
  def create_instance(key, instance_name), do: "#{key}:#{instance_name}"

  @doc ~S"""
  Returns the path of this key

  ## Examples

      iex> MerkleDAG.DataStore.Key.path("/Comedy/MontyPython/Actor:JohnCleese")
      "/Comedy/MontyPython/Actor"
  """
  def path(key) do
    p = parent(key)
    "#{p}#{@namespace_separator}#{type(key)}"
  end

  @doc ~S"""
  Returns the parent of the key

  ## Examples

      iex> MerkleDAG.DataStore.Key.parent("/Comedy/MontyPython/Actor:JohnCleese")
      "/Comedy/MontyPython"
  """
  def parent(key) when is_binary(key), do: parent(namespaces_from_key(key))
  def parent(ns) when length(ns) == 1, do: @namespace_separator
  def parent(ns), do:
  Enum.take(ns, length(ns)-1) |> (&([""|&1])).() |> Enum.join(@namespace_separator)

  @doc ~S"""
  Create the child of the key

  ## Examples

      iex> MerkleDAG.DataStore.Key.create_child_key("/Comedy/MontyPython", "Actor:JohnCleese")
      "/Comedy/MontyPython/Actor:JohnCleese"
  """
  def create_child_key(parent_key, child_key), do: "#{parent_key}#{@namespace_separator}#{child_key}"

  @doc ~S"""
  Checks whether `key` is ancestor of `other_key`

  ## Examples

      iex> MerkleDAG.DataStore.Key.ancestor_of?("/Comedy", "/Comedy/MontyPython")
      true
  """
  def ancestor_of?(key, other_key) when length(key) == length(other_key), do: false
  def ancestor_of?(key, other_key), do: String.starts_with?(other_key, key)

  @doc ~S"""
  Checks whether `key` is descendent of `other_key`

  ## Examples

      iex> MerkleDAG.DataStore.Key.descendant_of?("/Comedy/MontyPython", "/Comedy")
      true
  """
  def descendant_of?(key, other_key) when length(key) == length(other_key), do: false
  def descendant_of?(key, other_key), do: String.starts_with?(key, other_key)

  @doc ~S"""
  Returns if the `key` is the top level namespace

  ## Examples

      iex> MerkleDAG.DataStore.Key.top_level?("/Comedy")
      true
  """
  def top_level?(key), do: length(namespaces_from_key(key)) == 1

  def create_random_key(), do: @namespace_separator <> String.replace(UUID.uuid4, "-", "")
end
