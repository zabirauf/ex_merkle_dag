defprotocol MerkleDAG.DataStore do

  @type t :: any

  @type datastore :: t

  @type key :: MerkleDAG.DataStore.Key.t

  @type value :: term

  @type error :: {:error, term}

  @type on_datastore_change :: {:ok, datastore} | error

  @type on_get :: {:ok, value} | {:error, :not_found} | error 

  @type on_query :: {:ok, [value]} | error

  @doc """
  Puts the `value` at the `key` in the provided `datastore`

  Returns `{:ok, datastore}` or returns `{:error, reason}`
  """
  @spec put(datastore, key, value) :: on_datastore_change
  def put(datastore, key, value)

  @doc """
  Gets the value of the `key` in the provided `datastore`

  Returns `{:ok, value}` if key exists else `{:error, :not_found}` if key does not exist
  """
  @spec get(datastore, key) :: on_get
  def get(datastore, key)

  @doc """
  Tells if the datastore has the `key`
  """
  @spec has_key?(datastore, key) :: boolean
  def has_key?(datastore, key)

  @doc """
  Delete the entry related to `key`
  """
  @spec delete(datastore, key) :: on_datastore_change
  def delete(datastore, key)

  @doc """
  Executes the query and returns the values
  """
  @spec query(datastore, any) :: on_query
  def query(datastore, query)

end
