# add ssh rsa key to known_hosts
sshkey { $::fqdn:
  ensure       => present,
  key          => $::sshrsakey,
  host_aliases => $::ipaddress,
  target       => '/root/.ssh/known_hosts',
  type         => 'ssh-rsa',
}

# create directory for r10k config file
file { '/etc/puppetlabs/r10k':
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}

# install r10k
class { 'r10k':
  remote => "gitolite3@${::fqdn}:puppet-control.git",
}

# r10k class depends on r10k config directory
File['/etc/puppetlabs/r10k'] -> Class['r10k']
