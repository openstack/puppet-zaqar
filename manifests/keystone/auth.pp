# == Class: zaqar::keystone::auth
#
# Configures zaqar user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for zaqar user.
#
# [*auth_name*]
#   Username for zaqar service. Defaults to 'zaqar'.
#
# [*email*]
#   Email for zaqar user. Defaults to 'zaqar@localhost'.
#
# [*tenant*]
#   Tenant for zaqar user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should zaqar endpoint be configured? Defaults to 'true'.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to 'true'.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to 'true'.
#
# [*service_type*]
#   Type of service. Defaults to 'queue'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:8888')
#   This url should *not* contain any version or trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:8888')
#   This url should *not* contain any version or trailing '/'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:8888')
#   This url should *not* contain any version or trailing '/'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of auth_name.
#
#
class zaqar::keystone::auth (
  $password,
  $auth_name           = 'zaqar',
  $email               = 'zaqar@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = undef,
  $service_type        = 'queue',
  $admin_url           = 'http://127.0.0.1:8888',
  $internal_url        = 'http://127.0.0.1:8888',
  $public_url          = 'http://127.0.0.1:8888',
  $region              = 'RegionOne'
) {

  $real_service_name    = pick($service_name, $auth_name)

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'zaqar-server' |>
  }
  Keystone_endpoint["${region}/${real_service_name}"]  ~> Service <| name == 'zaqar-server' |>

  keystone::resource::service_identity { 'zaqar':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $real_service_name,
    service_type        => $service_type,
    service_description => 'zaqar queue service',
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    admin_url           => "${admin_url}/",
    internal_url        => "${internal_url}/",
    public_url          => "${public_url}/",
  }

}
