class jira::apache_install (
     $proxy_content = hiera ('apache_install::proxy_content')
    ) {

   package { 'httpd':
  ensure => installed
  }

   file  { '/etc/httpd/conf.d/default-site.conf':
  content => $proxy_content,
  require => Package['httpd']
  }

}
