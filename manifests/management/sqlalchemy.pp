# == class: zaqar::management::sqlalchemy
#
# [*uri*]
#   SQLAlchemy Connection URI. Required.
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to present.
#
class zaqar::management::sqlalchemy (
  $uri,
  Stdlib::Ensure::Package $package_ensure = 'present',
) {
  include zaqar::deps

  zaqar_config {
    'drivers:management_store:sqlalchemy/uri': value => $uri, secret => true;
  }

  oslo::db { 'zaqar_config':
    connection             => $uri,
    backend_package_ensure => $package_ensure,
    manage_config          => false,
  }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db['zaqar_config'] -> Anchor['zaqar::dbsync::begin']
}
