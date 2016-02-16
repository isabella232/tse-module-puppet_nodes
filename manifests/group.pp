application puppet_nodes::group () {

  $nodes.each |$node,$remainder| {
    $component = puppet_nodes_group_component_title($title, $node)
    puppet_nodes::component { $component:
      export => Puppet_nodes_component_token[$component],
    }
  }

}
