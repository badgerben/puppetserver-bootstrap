# add ssh key to known_hosts
sshkey { $::facts['networking']['fqdn']:
  ensure       => present,
  key          => $::facts['ssh']['ecdsa']['key'],
  host_aliases => $::facts['networking']['ip'],
  target       => '/root/.ssh/known_hosts',
  type         => 'ecdsa-sha2-nistp256',
}

# install r10k
class { 'r10k':
  remote => "gitolite3@${::facts['networking']['fqdn']}:puppet-control.git",
}

# install puppet-lint gem
package { 'puppet-lint':
  ensure   => present,
  provider => 'puppet_gem',
}

# install yaml-lint gem
package { 'yaml-lint':
  ensure   => present,
  provider => 'puppet_gem',
}

# install metadata-json-lint gem
package { 'metadata-json-lint':
  ensure   => present,
  provider => 'puppet_gem',
}

# install ra10ke gem
package { 'ra10ke':
  ensure   => present,
  provider => 'puppet_gem',
}
