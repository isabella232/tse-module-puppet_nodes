application puppet_nodes::group (
  $node_count,
) {

  $node_count.each |$i| {
    puppet_nodes::component { "${title}-${i}":
      export => Puppet_nodes_component_token["${title}-${i}"],
    }
  }

}
