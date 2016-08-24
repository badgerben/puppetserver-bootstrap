# install epel (stahnma-epel module)
class { 'epel': }

# install gitolite (echoes-gitolite module)
class { 'gitolite':
  admin_key_source    => 'file:///root/.ssh/id_rsa.pub',
  git_config_keys     => '.*',
  allow_local_code    => true,
  local_code_in_repo  => true,
  repo_specific_hooks => true,
  require             => Class['epel'],
}
