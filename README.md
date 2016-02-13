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

Or

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
        puppet_nodes::group { $name:
          node_count => $nodes.size,
          nodes      => $nodes.to_puppet_nodes_group_nodes($name),
        }
      }
    
    }
