# == Class: zaqar
#
# This class installs the base zaqar package and configure the configuration
# parameters common accross all zaqar services.
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
#   Defaults to $facts['os_service_default'].
#
# [*message_pipeline*]
#   Pipeline to use for processing message operations.
#   This pipeline will be consumed before calling the storage driver's
#   controller methods.
#   Defaults to $facts['os_service_default'].
#
# [*claim_pipeline*]
#   Pipeline to use for processing claim operations. This
#   pipeline will be consumed before calling the storage driver's controller
#   methods.
#   Defaults to $facts['os_service_default'].
#
# [*subscription_pipeline*]
#   Pipeline to use for processing subscription
#   operations. This pipeline will be consumed before calling the storage
#   driver's controller methods.
#   Defaults to $facts['os_service_default'].
#
# [*topic_pipeline*]
#   Pipeline to use for processing topic operations. This pipeline will be
#   consumed before calling the strage driver's controller methods.
#   Defaults to $facts['os_service_default'].
#
# [*max_messages_post_size*]
#   Defines the maximum size of message posts. (integer value)
#   Defaults to $facts['os_service_default'].
#
# [*message_store*]
#   Backend driver for message storage.
#   Defaults to $facts['os_service_default'].
#
# [*management_store*]
#   Backend driver for management storage.
#   Defaults to $facts['os_service_default'].
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
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the zaqar config.
#   Defaults to false.
#
class zaqar(
  $auth_strategy          = 'keystone',
  $admin_mode             = $facts['os_service_default'],
  $unreliable             = $facts['os_service_default'],
  $pooling                = $facts['os_service_default'],
  $queue_pipeline         = $facts['os_service_default'],
  $message_pipeline       = $facts['os_service_default'],
  $claim_pipeline         = $facts['os_service_default'],
  $subscription_pipeline  = $facts['os_service_default'],
  $topic_pipeline         = $facts['os_service_default'],
  $max_messages_post_size = $facts['os_service_default'],
  $message_store          = $facts['os_service_default'],
  $management_store       = $facts['os_service_default'],
  $package_name           = $::zaqar::params::package_name,
  $package_ensure         = 'present',
  Boolean $purge_config   = false,
) inherits zaqar::params {

  include zaqar::deps

  resources { 'zaqar_config':
    purge => $purge_config,
  }

  if $auth_strategy == 'keystone' {
    include zaqar::keystone::authtoken
    include zaqar::keystone::trust
  }

  package { 'zaqar-common':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => ['openstack', 'zaqar-package'],
  }

  zaqar_config {
    'DEFAULT/auth_strategy':            value => $auth_strategy;
    'DEFAULT/admin_mode':               value => $admin_mode;
    'DEFAULT/unreliable':               value => $unreliable;
    'DEFAULT/pooling':                  value => $pooling;
    'storage/queue_pipeline':           value => join(any2array($queue_pipeline), ',');
    'storage/message_pipeline':         value => join(any2array($message_pipeline), ',');
    'storage/claim_pipeline':           value => join(any2array($claim_pipeline), ',');
    'storage/subscription_pipeline':    value => join(any2array($subscription_pipeline), ',');
    'storage/topic_pipeline':           value => join(any2array($topic_pipeline), ',');
    'transport/max_messages_post_size': value => $max_messages_post_size;
    'drivers/message_store':            value => $message_store;
    'drivers/management_store':         value => $management_store;
  }

}
