# puppet\_nodes #

This module provides a mechanism for automatically creating an application instance for every node PuppetDB knows of, and for every group defined in the Node Classifier. The intended example use case is using the Puppet Application Orchestrator to run Puppet, on demand, on arbitrary nodes or node groups as defined in the NC.

The module depends on two Forge modules: `dalen/puppetdbquery` and `WhatsARanjit/node_manager`. These modules are used for functions, and for libraries that simplify interaction with PuppetDB and the NC, respectively.

To use this module code must be placed in the `site` block.

> Note: this module depends on the unreleased [node\_manager/pull/42 patch](https://github.com/puppetlabs/prosvcs-node_manager/pull/42).

## Installation ##

1. Install the `puppetclassify` gem

        /opt/puppetlabs/puppet/bin/gem install puppetclassify
        puppetserver gem install puppetclassify

2. Install the module and module dependencies. Some modules will need to be pulled from source due to required patches or Forge non-availability.

        curl -Lo node_manager.tar.gz https://github.com/reidmv/prosvcs-node_manager/archive/puppet_node_fixes.tar.gz
        curl -Lo puppet_nodes.tar.gz https://github.com/puppetlabs/tse-module-puppet_nodes/archive/master.tar.gz
        puppet module install dalen/puppetdbquery
        puppet module install --force node_manager.tar.gz
        puppet module install --force puppet_nodes.tar.gz

3. Edit your `site.pp` file to include the code shown below under Example Usage

## Example usage ##

```puppet
site {

  $all_nodes = query_nodes('')
  $all_nodes.each |$node| {
    puppet_nodes::node { $node:
      nodes => { Node[$node] => Puppet_nodes::Component[$node] },
    }
  }

  $node_groups = node_groups()
  $node_groups.each |$name,$data| {
    $nodes = node_group_members($data['rule'])
    $safename = $name.regsubst('/', '-', 'G')
    puppet_nodes::group { $safename:
      nodes => $nodes.to_puppet_nodes_group_nodes($name),
    }
  }

}
```

## Example Output ##

With the code above placed in the `site` block, the results of running the `puppet app show` command might look something like the following.

```
Puppet_nodes::Group['Agent-specified environment']

Puppet_nodes::Group['All Nodes']
    Puppet_nodes::Component['All Nodes: node3'] => node3
        - produces Puppet_nodes_component_token['All Nodes: node3']
    Puppet_nodes::Component['All Nodes: node1'] => node1
        - produces Puppet_nodes_component_token['All Nodes: node1']
    Puppet_nodes::Component['All Nodes: node4'] => node4
        - produces Puppet_nodes_component_token['All Nodes: node4']
    Puppet_nodes::Component['All Nodes: puppet-master'] => puppet-master
        - produces Puppet_nodes_component_token['All Nodes: puppet-master']
    Puppet_nodes::Component['All Nodes: node2'] => node2
        - produces Puppet_nodes_component_token['All Nodes: node2']

Puppet_nodes::Group['PE ActiveMQ Broker']
    Puppet_nodes::Component['PE ActiveMQ Broker: puppet-master'] => puppet-master
        - produces Puppet_nodes_component_token['PE ActiveMQ Broker: puppet-master']

Puppet_nodes::Group['PE Agent']

Puppet_nodes::Group['PE Certificate Authority']
    Puppet_nodes::Component['PE Certificate Authority: puppet-master'] => puppet-master
        - produces Puppet_nodes_component_token['PE Certificate Authority: puppet-master']

Puppet_nodes::Group['PE Console']
    Puppet_nodes::Component['PE Console: puppet-master'] => puppet-master
        - produces Puppet_nodes_component_token['PE Console: puppet-master']

Puppet_nodes::Group['PE Infrastructure']

Puppet_nodes::Group['PE MCollective']

Puppet_nodes::Group['PE Master']
    Puppet_nodes::Component['PE Master: puppet-master'] => puppet-master
        - produces Puppet_nodes_component_token['PE Master: puppet-master']

Puppet_nodes::Group['PE Orchestrator']
    Puppet_nodes::Component['PE Orchestrator: puppet-master'] => puppet-master
        - produces Puppet_nodes_component_token['PE Orchestrator: puppet-master']

Puppet_nodes::Group['PE PuppetDB']
    Puppet_nodes::Component['PE PuppetDB: puppet-master'] => puppet-master
        - produces Puppet_nodes_component_token['PE PuppetDB: puppet-master']

Puppet_nodes::Group['Production environment']
    Puppet_nodes::Component['Production environment: node1'] => node1
        - produces Puppet_nodes_component_token['Production environment: node1']
    Puppet_nodes::Component['Production environment: node2'] => node2
        - produces Puppet_nodes_component_token['Production environment: node2']
    Puppet_nodes::Component['Production environment: node3'] => node3
        - produces Puppet_nodes_component_token['Production environment: node3']
    Puppet_nodes::Component['Production environment: puppet-master'] => puppet-master
        - produces Puppet_nodes_component_token['Production environment: puppet-master']
    Puppet_nodes::Component['Production environment: node4'] => node4
        - produces Puppet_nodes_component_token['Production environment: node4']

Puppet_nodes::Node['node1']
    Puppet_nodes::Component['node1'] => node1
        - produces Puppet_nodes_component_token['node1']

Puppet_nodes::Node['node2']
    Puppet_nodes::Component['node2'] => node2
        - produces Puppet_nodes_component_token['node2']

Puppet_nodes::Node['node3']
    Puppet_nodes::Component['node3'] => node3
        - produces Puppet_nodes_component_token['node3']

Puppet_nodes::Node['node4']
    Puppet_nodes::Component['node4'] => node4
        - produces Puppet_nodes_component_token['node4']

Puppet_nodes::Node['puppet-master']
    Puppet_nodes::Component['puppet-master'] => puppet-master
        - produces Puppet_nodes_component_token['puppet-master']
```
