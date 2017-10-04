class jira::jira_configure (
     $dbconf_content = hiera ('jira_configure::dbconf_content')
    ) {

	exec { 'tomcat fix':
    command => "sed -i '62i\\proxyName=\"jiracluster\"\\n proxyPort=\"80\"\\n scheme=\"http\"' /opt/atlassian/jira/conf/server.xml; touch /tmp/tomcat_fix",
		path => '/usr/bin',
		unless => '/usr/bin/test -f /tmp/tomcat_fix',
		require => File['/etc/httpd/conf.d/default-site.conf']
		}


	   service { 'httpd':
	  ensure    => running,
	  enable    => true,
	  subscribe => Exec['tomcat fix'],
	  }

	


	file { '/var/atlassian/application-data/jira/dbconfig.xml' :
		content => $dbconf_content,
		require => Service['httpd']
		}

	
	exec { 'restart jira':
		command => '/opt/atlassian/jira/bin/start-jira.sh ',
		path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
		cwd => '/opt/atlassian/jira/bin',
		require => File['/var/atlassian/application-data/jira/dbconfig.xml']
	}
 

	exec { 'restart httpd':
		command => '/bin/systemctl restart  httpd.service',
		path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
		require => Exec['restart jira']

	}
}
