Puppet::Type.newtype :puppet_nodes_component_token, :is_capability => true do
  newparam :name, :is_namevar => true
end
