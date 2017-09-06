class nginx::launch (
    ) {
  service { 'nginxstart':
    name => nginx,
    ensure => running,
  }

}


