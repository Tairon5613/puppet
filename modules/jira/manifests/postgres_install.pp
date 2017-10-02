class jira::postgres_install (
    ) {


   package { 'postgresql-server':
	ensure => installed
	}

   user { 'jirauser': 
 	 ensure   => present,
  	password => '$1$87aO9iis$bcqwFErtk1/WShAuMMwhr.'
	}

   exec { 'initialise db':
	command => 'postgresql-setup initdb',
	path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
	user => root,
        unless => '/usr/bin/test -f /var/lib/pgsql/data/postgresql.conf',
	require => Package['postgresql-server']
	}

   exec { 'pg_hba fix':
	command => "sed -i -e 's/127.0.0.1\/32/0.0.0.0\/0/g' /var/lib/pgsql/data/pg_hba.conf ; sed -i -e 's/ident/trust/g' /var/lib/pgsql/data/pg_hba.conf ; sed -i \"59i\listen_addresses\ =\ \'0.0.0.0\'\" /var/lib/pgsql/data/postgresql.conf ",
	path => '/usr/bin',
	require => Exec['initialise db']
	}

   service {'postgresql':
	ensure => running,
	require => Exec['pg_hba fix']
	} 

   exec { 'create_postgres_user' :
	command => 'createuser -e jirauser -s ; createdb jira',
	user => postgres,
	path => '/usr/bin',
	require => Service['postgresql'],
	unless => "psql -t -c '\\du' | cut -d \\| -f 1 | grep -qw jirauser"
	}

	

}
