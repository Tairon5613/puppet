class nginx::configure (
        String $content
    ) {
  file { '/usr/share/nginx/html/index.html':
    ensure  => file,
    content => @("END"),
                <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
                    <body>
                    <div> ${content} </div>
                    <div> Data from enironment: ${environment} </div>
                    </body>
                </html>
               |END
    owner   => root,
    mode    => '0644',
  }

  exec { 'nginxstop':
    command => 'nginx -s reload',
    require => File['/usr/share/nginx/html/index.html']
  }

}


