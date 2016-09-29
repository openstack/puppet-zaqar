#
# Class to execute "zaqar-manage db_sync
#
class zaqar::db::sync {
  exec { 'zaqar-manage db_sync':
    path        => '/usr/bin',
    user        => 'zaqar',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    subscribe   => [Package['zaqar'], Zaqar_config['database/connection']],
  }

  Exec['zaqar-manage db_sync'] ~> Service<| title == 'zaqar' |>
}
