#
# Class to execute "zaqar-sql-db-manage upgrade head"
#
# ==Parameters
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class zaqar::db::sync(
  $db_sync_timeout = 300,
) {

  include zaqar::deps
  include zaqar::params

  exec { 'zaqar-db-sync':
    command     => 'zaqar-sql-db-manage upgrade head',
    path        => '/usr/bin',
    user        => $zaqar::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['zaqar::install::end'],
      Anchor['zaqar::config::end'],
      Anchor['zaqar::dbsync::begin']
    ],
    notify      => Anchor['zaqar::dbsync::end'],
    tag         => 'openstack-db',
  }

}
