# install epel (stahnma-epel module)
include epel

# install gitolite (echoes-gitolite module)
class { 'gitolite':
  admin_key_source    => 'file:///root/.ssh/id_rsa.pub',
  git_config_keys     => '.*',
  umask               => '0077',
  allow_local_code    => true,
  local_code_in_repo  => true,
  repo_specific_hooks => true,
}

# gitolite depends on epel
Class['epel'] -> Class['gitolite']
