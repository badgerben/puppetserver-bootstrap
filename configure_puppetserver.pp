# epp template for wrapper script
$delete_environment_cache_template = @("END"/$L)
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

# install puppetserver package
package { 'puppetserver':
  ensure => present,
}

# set environment_timeout in puppet.conf
ini_setting { 'environment_timeout':
  ensure  => present,
  path    => $::settings::config,
  section => 'master',
  setting => 'environment_timeout',
  value   => 'unlimited',
  notify  => Service['puppetserver'],
  require => Package['puppetserver'],
}

# start and enable service
service { 'puppetserver':
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  require    => Package['puppetserver'],
}
