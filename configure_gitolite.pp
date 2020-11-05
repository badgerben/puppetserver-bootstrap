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
