# == Class: zaqar
#
# Full description of class zaqar here.
#
# === Parameters
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
# [*max_messages_post_size*]
#   Defines the maximum size of message posts. (integer value)
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
# = DEPRECATED PARAMETERS
#
# [*identity_uri*]
#   (Optional) DEPRECATED. Use zaqar::keystone::authtoken::auth_url instead.
#   Defaults to undef
#
# [*auth_uri*]
#   (Optional) DEPRECATED. Use zaqar::keystone::authtoken::auth_uri instead.
#   Defaults to undef
#
# [*admin_user*]
#   (Optional) DEPRECATED. Use zaqar::keystone::authtoken::username instead.
#   Defaults to undef
#
# [*admin_tenant_name*]
#   (Optional) DEPRECATED. Use zaqar::keystone::authtoken::project_name instead.
#   Defaults to undef
#
# [*admin_password*]
#   (Optional) DEPRECATED. Use zaqar::keystone::authtoken::password instead.
#   Defaults to undef
#
class zaqar(
  $auth_strategy                  = 'keystone',
  $admin_mode                     = $::os_service_default,
  $unreliable                     = $::os_service_default,
  $pooling                        = $::os_service_default,
  $queue_pipeline                 = $::os_service_default,
  $message_pipeline               = $::os_service_default,
  $claim_pipeline                 = $::os_service_default,
  $subscription_pipeline          = $::os_service_default,
  $max_messages_post_size         = $::os_service_default,
  $package_name                   = $::zaqar::params::package_name,
  $package_ensure                 = 'present',
  # Deprecated
  $identity_uri                   = undef,
  $auth_uri                       = undef,
  $admin_user                     = undef,
  $admin_password                 = undef,
  $admin_tenant_name              = undef,
) inherits zaqar::params {


  if $identity_uri {
    warning('zaqar::identity_uri is deprecated, use zaqar::keystone::authtoken::auth_url instead')
  }

  if $auth_uri {
    warning('zaqar::auth_uri is deprecated, use zaqar::keystone::authtoken::auth_uri instead')
  }

  if $admin_user {
    warning('zaqar::admin_user is deprecated, use zaqar::keystone::authtoken::username instead')
  }

  if $admin_password {
    warning('zaqar::admin_password is deprecated, use zaqar::keystone::authtoken::password instead')
  }

  if $admin_tenant_name {
    warning('zaqar::admin_tenant_name is deprecated, use zaqar::keystone::authtoken::project_name instead')
  }


  if $auth_strategy == 'keystone' {
    include ::zaqar::keystone::authtoken
  }

  package { 'zaqar-common':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => ['openstack', 'zaqar-package'],
  }

  zaqar_config {
    'DEFAULT/auth_strategy':            value  => $auth_strategy;
    'DEFAULT/admin_mode':               value  => $admin_mode;
    'DEFAULT/unreliable':               value  => $unreliable;
    'DEFAULT/pooling':                  value  => $pooling;
    'storage/queue_pipeline':           value  => $queue_pipeline;
    'storage/message_pipeline':         value  => $message_pipeline;
    'storage/claim_pipeline':           value  => $claim_pipeline;
    'storage/subscription_pipeline':    value  => $subscription_pipeline;
    'transport/max_messages_post_size': value  => $max_messages_post_size;
  }

}
