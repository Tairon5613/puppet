
class write_hostname::create_file (
    ) {
  file { '/tmp/hostname.txt':
    ensure  => file,
    content => @("END"),
               Data from enironment: ${environment}
               -----
               hostname: ${hostname}
               |END
    owner   => root,
    mode    => '0644',
  }
}


