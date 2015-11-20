# epp template for wrapper script
$delete_environment_cache_template = @("END"/L)
	#!/bin/bash
	# Wrapper script to delete Puppet Server environment cache using curl
	/usr/bin/curl -s --cert $::settings::hostcert --key $::settings::hostprivkey \
	--cacert $::settings::cacert -X DELETE \
	https://${::fqdn}:8140/puppet-admin-api/v1/environment-cache
	| END

# create wrapper script for deleting environment cache
file { '/usr/local/sbin/delete_environment_cache.sh':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  content => inline_epp($delete_environment_cache_template),
}

# install puppet-lint gem
package { 'puppet-lint':
  ensure   => installed,
  provider => 'puppet_gem',
}

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
