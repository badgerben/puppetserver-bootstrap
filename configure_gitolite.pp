# install epel (puppet-epel module)
class { 'epel':
  epel_enabled => '0', # managed via foreman
}

# install gitolite (echoes-gitolite module)
class { 'gitolite':
  admin_key_source    => 'file:///root/.ssh/id_rsa.pub',
  git_config_keys     => '.*',
  allow_local_code    => true,
  local_code_in_repo  => true,
  repo_specific_hooks => true,
  require             => Class['epel'],
}

# create sudo config for gitolite3 user
file { '/etc/sudoers.d/10_gitolite3':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0440',
  content => "Defaults:gitolite3 !requiretty\ngitolite3 ALL=(root) NOPASSWD: /usr/bin/r10k, /usr/local/sbin/delete_environment_cache.sh\n",
}
