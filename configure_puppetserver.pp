# epp template for wrapper script
$delete_environment_cache_template = @("END"/$)
	#!/bin/bash
	#
	# This file is managed by Puppet
	#
	# Wrapper script to delete Puppetserver environment cache using curl
	#
	
	BRANCH=""
	
	if [ ! -z "\$1" ]; then
	  BRANCH="?environment=\$1"
	fi
	
	/usr/bin/curl -s --cert $::settings::hostcert --key $::settings::hostprivkey \
	--cacert $::settings::cacert -X DELETE \
	https://${::fqdn}:8140/puppet-admin-api/v1/environment-cache\$BRANCH
	| END

# create wrapper script for deleting environment cache
file { '/usr/local/sbin/delete_environment_cache.sh':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0750',
  content => inline_epp($delete_environment_cache_template),
}

# install puppet-lint gem
package { 'puppet-lint':
  ensure   => present,
  provider => 'puppet_gem',
}

# install puppetserver package
package { 'puppetserver':
  ensure => present,
}

# default params for ini_setting
Ini_setting {
  ensure  => present,
  path    => $::settings::config,
  section => 'master',
}

# set environment_timeout in puppet.conf
ini_setting { 'environment_timeout':
  setting => 'environment_timeout',
  value   => 'unlimited',
}

# fix pidfile setting in puppet.conf
ini_setting { 'pidfile':
  setting => 'pidfile',
  value   => '/var/run/puppetlabs/puppetserver/puppetserver',
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

