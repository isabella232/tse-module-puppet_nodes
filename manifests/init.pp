application all (
  $node_count,
) {

  $node_count.each |$i| {
    all::member { "${title}-${i}":
      exports => All_token[$title],
    }
  }

}
