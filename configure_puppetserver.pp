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

# fix pidfile setting in puppet.conf
ini_setting { 'pidfile':
  ensure  => present,
  path    => $::settings::config,
  section => 'master',
  setting => 'pidfile',
  value   => '/var/run/puppetlabs/puppetserver/puppetserver',
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

# puppet.conf settings notify service
Ini_setting['environment_timeout'] ~> Service['puppetserver']
Ini_setting['pidfile'] ~> Service['puppetserver']

# puppetserver.conf settings notify service
Hocon_setting['client-whitelist'] ~> Service['puppetserver']
