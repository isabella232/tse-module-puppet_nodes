Puppet::Functions.create_function(:to_all_nodes) do
  dispatch :resolve do
    param 'Array',  :input
    param 'String', :title
  end

  def resolve(input)
    iter = 0
    input.inject({}) do |hash,node|
      key = Puppet::Resource.new(nil, "Node[#{node}]", {})
      val = Puppet::Resource.new(nil, "All::Member[#{title}-#{iter.to_s}]", {})
      hash[key] = val
      iter++
      hash
    end
  end
end
