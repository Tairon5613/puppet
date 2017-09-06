class nginx::launch (
    ) {
  service { 'nginx':
    ensure => running,
  }

}


