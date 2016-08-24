# add ssh rsa key to known_hosts
sshkey { $::fqdn:
  ensure       => present,
  key          => $::sshrsakey,
  host_aliases => $::ipaddress,
  target       => '/root/.ssh/known_hosts',
  type         => 'ssh-rsa',
}

# install r10k
class { 'r10k':
  remote   => "gitolite3@${::fqdn}:puppet-control.git",
  cachedir => '/opt/puppetlabs/puppet/cache/r10k',
}
