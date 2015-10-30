# install epel (stahnma-epel module)
include epel

# install gitolite (echoes-gitolite module)
class { 'gitolite':
  admin_key_source    => 'file:///root/.ssh/id_rsa.pub',
  git_config_keys     => '.*',
  repo_specific_hooks => true,
}

# gitolite depends on epel
Class['epel'] -> Class['gitolite']
