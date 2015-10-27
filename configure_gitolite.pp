# install epel (stahnma-epel module)
include epel

# install gitolite (echoes-gitolite module)
class { 'gitolite':
  admin_key_source => 'file:///root/.ssh/id_rsa.pub',
}

# gitolite depends on epel
Class['epel'] -> Class['gitolite']
