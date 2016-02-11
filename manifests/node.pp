application puppet_nodes::node () {

  puppet_nodes::component { $title:
    export => Puppet_nodes_component_token[$title],
  }

}
