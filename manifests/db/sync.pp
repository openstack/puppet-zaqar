#
# Class to execute "zaqar-manage db_sync
#
class zaqar::db::sync {

  include ::zaqar::deps

  exec { 'zaqar-manage db_sync':
    path        => '/usr/bin',
    user        => 'zaqar',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    subscribe   => [
      Anchor['zaqar::install::end'],
      Anchor['zaqar::config::end'],
      Anchor['zaqar::dbsync::begin']
    ],
    notify      => Anchor['zaqar::dbsync::end'],
  }

}
