Puppet::Functions.create_function(:puppet_nodes_group_component_title) do
  dispatch :from_strings do
    param 'String', :group
    param 'String', :node
  end

  dispatch :from_type do
    param 'String', :group
    param 'Type',   :node
  end

  def from_strings(group, node)
    "#{group}: #{node}"
  end

  def from_type(group, node)
    from_strings(group, node.title)
  end
end
