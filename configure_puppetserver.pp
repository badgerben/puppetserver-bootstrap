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

# add puppet master cert to admin api whitelist
hocon_setting { 'client-whitelist':
  ensure  => present,
  path    => '/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf',
  setting => 'puppet-admin.client-whitelist',
  value   => [$::fqdn],
  type    => 'array',
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
