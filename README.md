Example usage


    site {
    
      $nodes = ['node1', 'node2']
      $all_nodes.each |$node| {
        puppet_nodes::node { $node:
          nodes => { Node[$node] => Puppet_nodes::Component[$node] },
        }
      }
    
      puppet_nodes::group { 'all':
        node_count => $nodes.size,
        nodes      => $nodes.to_puppet_nodes_group_nodes('all'),
      }
    
    }
