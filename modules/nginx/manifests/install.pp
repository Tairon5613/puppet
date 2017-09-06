class nginx::install (
    ) {
     
    package { 'epel-release':
      ensure => installed,
    }

    package { 'nginx':
      ensure => installed,   
    }
}


