# add ssh rsa key to known_hosts
sshkey { $::fqdn:
  ensure => present,
  key    => $::sshrsakey,
  target => '/root/.ssh/known_hosts',
  type   => 'ssh-rsa',
}

# install r10k
class { 'r10k':
  remote => "gitolite3@${::fqdn}:puppet-control.git",
}
