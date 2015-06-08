defmodule MerkleDAG.Key do

  # @type Key::string

  @namespace_separator "/"

  def create_key_from_namespaces(namespaces), do: Enum.join(namespaces, @namespace_separator)

  def equal(key1, key2), do: key1 === key2

  def to_bytes(key), do: <<key>>

  def less?(key_lhs, key_rhs) when is_binary(key_lhs) and is_binary(key_rhs), do:
  less?(namespaces_from_key(key_lhs), namespaces_from_key(key_rhs))

  def less?([], [_ns_rhs|_]), do: true
  def less?([_ns_lhs|_], []), do: false
  def less?([ns_lhs|_], [ns_rhs|_]) when ns_lhs < ns_rhs, do: true
  def less?([ns_lhs|_], [ns_rhs|_]) when ns_rhs < ns_lhs, do: false
  def less?([_|kn_lhs], [_|kn_rhs]), do: less?(kn_lhs, kn_rhs)

  def namespaces_from_key(key), do: String.split(key, @namespace_separator)

  def reverse(key), do: String.reverse(key)

  def base_namespace(key), do: Enum.take(namespaces_from_key(key), -1)

  def type(key) do
    nil
  end

  def create_instance(key, instance_name), do: "#{key}:#{instance_name}"

  def path(key) do
    nil
  end

  def parent(key) when is_binary(key), do: parent(namespaces_from_key(key))
  def parent(ns) when length(ns) == 1, do: @namespace_separator
  def parent(ns), do:
  Enum.take(ns, length(ns)-1) |> Enum.join(@namespace_separator)


  def child(parent_key, child_key), do: "#{parent_key}#{@namespace_separator}#{child_key}"

  def ancestor_of?(key, other_key) when length(key) == length(other_key), do: false
  def ancestor_of?(key, other_key), do: String.starts_with?(other_key, key)

  def descendant_of?(key, other_key) when length(key) == length(other_key), do: false
  def descendant_of?(key, other_key), do: String.starts_with?(key, other_key)

  def top_level?(key), do: length(namespaces_from_key(key)) == 1

  def create_random_key(), do: @namespace_separator ++ String.replace(UUID.uuid4, "-", "")

end
