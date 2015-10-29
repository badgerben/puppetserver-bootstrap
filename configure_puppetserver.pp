# install puppetserver package
package { 'puppetserver':
  ensure => installed,
}

# set environment_timeout in puppet.conf
ini_setting { 'environment_timeout':
  ensure  => present,
  path    => $::settings::config,
  section => 'master',
  setting => 'environment_timeout',
  value   => 'unlimited',
}

# start and enable service
service { 'puppetserver':
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
}

# service depends on package
Package['puppetserver'] -> Service['puppetserver']

# puppet.conf settings notifies service
Ini_setting['environment_timeout'] ~> Service['puppetserver']
