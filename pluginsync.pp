# Perform pluginsync when using puppet apply
file { $::settings::libdir:
  ensure  => directory,
  recurse => true,
  source  => 'puppet:///plugins',
  force   => true,
  purge   => true,
  backup  => false,
  noop    => false,
}
