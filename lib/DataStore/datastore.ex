defprotocol MerkleDAG.DataStore do

  def put(datastore, key, value)

  def get(datastore, key)

  def has_key?(datastore, key)

  def delete(datastore, key)

  def query(datastore, query)

end
