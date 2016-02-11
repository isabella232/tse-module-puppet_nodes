application node_group (
  $node_count,
) {

  $node_count.each |$i| {
    node_group::member { "${title}-${i}":
      export => Node_group_member_token["${title}-${i}"],
    }
  }

}
