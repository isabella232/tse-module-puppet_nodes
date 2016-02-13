require 'puppet/util/puppetdb'

begin
  require 'puppet/util/node_groups'
  require 'puppetdb/connection'
rescue LoadError
  node_manager  = Puppet::Module.find('node_manager',  Puppet[:environment].to_s)
  puppetdbquery = Puppet::Module.find('puppetdbquery', Puppet[:environment].to_s)
  require File.join node_manager.path,  'lib/puppet/util/node_groups'
  require File.join puppetdbquery.path, 'lib/puppetdb/connection'
end

Puppet::Functions.create_function(:node_group_members) do
  dispatch :empty do
    param 'Undef', :param
  end

  dispatch :rules do
    param 'Array', :array
  end

  def empty(empty)
    [ ]
  end

  def rules(rules)
    @ng ||= Puppet::Util::Node_groups.new
    query = @ng.rules.translate(rules)['query']

    @uri ||= URI(Puppet::Util::Puppetdb.config.server_urls.first)
    @puppetdb ||= PuppetDB::Connection.new(@uri.host, @uri.port, @uri.scheme == 'https')
    @puppetdb.query(:nodes, query, :extract => :certname).collect { |n| n['certname'] }
  end
end
