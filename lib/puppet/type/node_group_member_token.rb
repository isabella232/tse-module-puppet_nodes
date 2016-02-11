Puppet::Type.newtype :node_group_member_token, :is_capability => true do
  newparam :name, :is_namevar => true
end
