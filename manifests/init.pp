# == Class: zaqar
#
# Full description of class zaqar here.
#
# === Parameters
#
# [*auth_uri*]
#   Specifies the public Identity URI for Zaqar to use.
#   Default 'http://localhost:5000/'
#
# [*identity_uri*]
#   Specifies the admin Identity URI for Zaqar to use.
#   Default 'http://localhost:35357/'
#
# [*admin_user*]
#   The user name from 'zaqar::keystone::auth'. Default 'zaqar'
#
# [*admin_tenant_name*]
#   The tenant name from 'zaqar::keystone::auth'. Default 'services'
#
# [*admin_password*]
#   The password  from 'zaqar::keystone::auth'. Default 'password'
#
# [*auth_strategy*]
#   Backend to use for authentication. For no auth, keep it empty.
#   Default 'keystone'.
#
# [*admin_mode*]
#   Activate privileged endpoints. (boolean value)
#   Default false
#
# [*pooling*]
#   Enable pooling across multiple storage backends. If pooling is
#   enabled, the storage driver configuration is used to determine where
#   the catalogue/control plane data is kept. (boolean value)
#   Default false
#
# [*queue_pipeline*]
#   Pipeline to use for processing queue operations.
#   This pipeline will be consumed before calling the storage driver's
#   controller methods.
#   Defaults to $::os_service_default.
#
# [*message_pipeline*]
#   Pipeline to use for processing message operations.
#   This pipeline will be consumed before calling the storage driver's
#   controller methods.
#   Defaults to $::os_service_default.
#
# [*claim_pipeline*]
#   Pipeline to use for processing claim operations. This
#   pipeline will be consumed before calling the storage driver's controller
#   methods.
#   Defaults to $::os_service_default.
#
# [*subscription_pipeline*]
#   Pipeline to use for processing subscription
#   operations. This pipeline will be consumed before calling the storage
#   driver's controller methods.
#   Defaults to $::os_service_default.
#
# [*unreliable*]
#   Disable all reliability constraints. (boolean value)
#   Default false
#
# [*package_name*]
#   (Optional) Package name to install for zaqar.
#   Defaults to $::zaqar::params::package_name
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to present.
#
class zaqar(
  $admin_password,
  $auth_uri                 = 'http://localhost:5000/',
  $identity_uri             = 'http://localhost:35357/',
  $admin_user               = 'zaqar',
  $admin_tenant_name        = 'services',
  $auth_strategy            = 'keystone',
  $admin_mode               = $::os_service_default,
  $unreliable               = $::os_service_default,
  $pooling                  = $::os_service_default,
  $queue_pipeline           = $::os_service_default,
  $message_pipeline         = $::os_service_default,
  $claim_pipeline           = $::os_service_default,
  $subscription_pipeline    = $::os_service_default,
  $package_name             = $::zaqar::params::package_name,
  $package_ensure    = 'present',
) inherits zaqar::params {

  package { 'zaqar-common':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => ['openstack', 'zaqar-package'],
  }

  zaqar_config {
    'keystone_authtoken/auth_uri'          : value  => $auth_uri;
    'keystone_authtoken/identity_uri'      : value  => $identity_uri;
    'keystone_authtoken/admin_user'        : value  => $admin_user;
    'keystone_authtoken/admin_password'    : value  => $admin_password;
    'keystone_authtoken/admin_tenant_name' : value  => $admin_tenant_name;
    'DEFAULT/auth_strategy'                : value  => $auth_strategy;
    'DEFAULT/admin_mode'                   : value  => $admin_mode;
    'DEFAULT/unreliable'                   : value  => $unreliable;
    'DEFAULT/pooling'                      : value  => $pooling;
    'storage/queue_pipeline'               : value  => $queue_pipeline;
    'storage/message_pipeline'             : value  => $message_pipeline;
    'storage/claim_pipeline'               : value  => $claim_pipeline;
    'storage/subscription_pipeline'        : value  => $subscription_pipeline;
  }

}
