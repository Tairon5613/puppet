class nginx{
  include nginx::install
  include nginx::configure
  include nginx::launch
}
