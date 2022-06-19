# == Class: zaqar::keystone::auth_websocket
#
# Configures zaqar-websocket user, service and endpoint in Keystone.
#
# === Parameters
#
# [*configure_endpoint*]
#   (Optional) Should zaqar websocket endpoint be configured?
#   Defaults to 'true'.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'messaging-websocket'.
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   Defaults to 'ws://127.0.0.1:9000'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   Defaults to 'ws://127.0.0.1:9000'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   Defaults to 'ws://127.0.0.1:9000'
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'zaqar-websocket'
#
# [*configure_service*]
#   (Optional) Should zaqar websocket service be configured?
#   Defaults to 'true'.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'OpenStack Messaging Websocket Service'.
#
class zaqar::keystone::auth_websocket(
  $service_name        = 'zaqar-websocket',
  $service_type        = 'messaging-websocket',
  $public_url          = 'ws://127.0.0.1:9000',
  $admin_url           = 'ws://127.0.0.1:9000',
  $internal_url        = 'ws://127.0.0.1:9000',
  $region              = 'RegionOne',
  $configure_endpoint  = true,
  $configure_service   = true,
  $service_description = 'OpenStack Messaging Websocket Service',
) {

  include zaqar::deps

  Keystone::Resource::Service_identity['zaqar-websocket'] -> Anchor['zaqar::service::end']

  keystone::resource::service_identity { 'zaqar-websocket':
    configure_user      => false,
    configure_user_role => false,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    region              => $region,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }
}
