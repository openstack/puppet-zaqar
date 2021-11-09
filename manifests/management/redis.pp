# == class: zaqar::management::redis
#
# [*uri*]
#   Redis connection URI. Required.
#
# [*max_reconnect_attempts*]
#   Maximum number of times to retry an operation that failed due to a redis
#   node failover.
#   Defaults to $::os_service_default
#
# [*reconnect_sleep*]
#   Base sleep interval between attempts to reconnect after a redis node
#   failover.
#   Defaults to $::os_service_default
#
class zaqar::management::redis(
  $uri,
  $max_reconnect_attempts = $::os_service_default,
  $reconnect_sleep        = $::os_service_default,
) {

  include zaqar::deps

  zaqar_config {
    'drivers:management_store:redis/uri':                    value => $uri, secret => true;
    'drivers:management_store:redis/max_reconnect_attempts': value => $max_reconnect_attempts;
    'drivers:management_store:redis/reconnect_sleep':        value => $reconnect_sleep;
  }

}
