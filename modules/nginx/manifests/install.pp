class nginx::install (
    ) {
     
    package { 'epel-release':
      ensure => installed,
    }

}


