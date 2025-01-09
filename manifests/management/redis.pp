# == class: zaqar::management::redis
#
# [*uri*]
#   (Required) Redis Connection URI.
#
# [*max_reconnect_attempts*]
#   (Optional) Maximum number of times to retry an operation that failed due to
#   a primary node failover.
#   Defaults to $facts['os_service_default'].
#
# [*reconnect_sleep*]
#   (Optional) Base sleep interval between attempts to reconnect after
#   a primary node failover.
#   Defaults to $facts['os_service_default'].
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'
#
# [*manage_package*]
#   (Optional) Manage pyhton-redis package.
#   Defaults to true
#
class zaqar::management::redis(
  $uri,
  $max_reconnect_attempts = $facts['os_service_default'],
  $reconnect_sleep        = $facts['os_service_default'],
  $package_ensure         = 'present',
  Boolean $manage_package = true,
) {

  include zaqar::deps
  include zaqar::params

  zaqar_config {
    'drivers:management_store:redis/uri':                    value => $uri, secret => true;
    'drivers:management_store:redis/max_reconnect_attempts': value => $max_reconnect_attempts;
    'drivers:management_store:redis/reconnect_sleep':        value => $reconnect_sleep;
  }

  if $manage_package {
    ensure_packages('python-redis', {
      name   => $::zaqar::params::python_redis_package_name,
      ensure => $package_ensure,
      tag    => ['openstack'],
    })

    Anchor['zaqar::install::begin']
    -> Package<| name == $::zaqar::params::python_redis_package_name |>
    -> Anchor['zaqar::install::end']
  }
}
