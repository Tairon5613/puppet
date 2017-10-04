class jira::jira_install (
	$varfile = hiera('jira_install::varfile'),
	$url = hiera('jira_install::url')
){

 exec { 'Download Jira':
	command => "cd /tmp; wget ${url} ",
	path => "/usr/bin",
	unless => "/usr/bin/test -f /tmp/atlassian-jira-software-7.5.0-x64.bin "
}

 file { '/tmp/atlassian-jira-software-7.5.0-x64.bin':
	ensure => file,
	mode => "0775",
	require => Exec['Download Jira']
	}
 file { '/tmp/response.varfile':
	ensure => file,
	mode => "0775",
	content => $varfile,
	require => File['/tmp/atlassian-jira-software-7.5.0-x64.bin']
	}
 exec { 'Run installation Jira':
	command => "/tmp/atlassian-jira-software-7.5.0-x64.bin -q -varfile /tmp/response.varfile",
	path => "/usr/bin",
	unless => "/usr/bin/test -f /opt/JIRA\\ Software/bin/start-jira.sh",
	require => File['/tmp/response.varfile']
	}

 exec { 'installation fix':
  command => "mkdir /opt/atlassian ; mv /opt/JIRA\\ Software /opt/atlassian/jira ; sed -i -e 's/jira1/jira/g' /opt/atlassian/jira/  bin/user.sh; sed -i -e  's/cd \"\\/opt\\/cd \"\\/opt\\/atlassian\\/jira\\/bin\"/g' /etc/init.d/jira; sed -i -e 's/Software\\/bin\"/ \\ /g' /etc/init.d/jira; sed -i -e 's/JAVA_HOME=\"\\/opt\\/JIRA\\ Software\\/jre\\/\"\\;\\ export\\ JAVA_HOME/JAVA_HOME=\"\\/opt\\/ atlassian\\/jira\\/jre\"\\ export\\ JAVA_HOME/g'  /opt/atlassian/jira/bin/setenv.sh ",
	 path => "/usr/bin", 
	require => Exec['Run installation Jira']
	}
}
