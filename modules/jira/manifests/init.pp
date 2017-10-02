class jira{
  include jira::jira_install
  include jira::postgres_install
  include jira::apache_install
  include jira::jira_configure
}
