Puppet::Functions.create_function(:to_node_group_nodes) do
  dispatch :resolve do
    param 'Array',  :input
    param 'String', :title
  end

  def resolve(input, title)
    iter = 0
    input.inject({}) do |hash,node|
      key = Puppet::Resource.new(nil, "Node[#{node}]", {})
      val = Puppet::Resource.new(nil, "Node_group::Member[#{title}-#{iter.to_s}]", {})
      hash[key] = val
      iter += 1
      hash
    end
  end
end