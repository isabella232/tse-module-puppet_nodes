Puppet::Type.newtype :all_token, :is_capability => true do
  newparam :name, :is_namevar => true
end
