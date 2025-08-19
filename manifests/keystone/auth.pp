# == Class: zaqar::keystone::auth
#
# Configures zaqar user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for zaqar user.
#
# [*auth_name*]
#   (Optional) Username for zaqar service.
#   Defaults to 'zaqar'.
#
# [*email*]
#   (Optional) Email for zaqar user.
#   Defaults to 'zaqar@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for zaqar user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to neutron user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to neutron user.
#   Defaults to []
#
# [*configure_endpoint*]
#   (Optional) Should zaqar endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'messaging'.
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   (Defaults to 'http://127.0.0.1:8888')
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   (Defaults to 'http://127.0.0.1:8888')
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   (Defaults to 'http://127.0.0.1:8888')
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'zaqar'
#
# [*configure_service*]
#   (Optional) Should zaqar service be configured?
#   Defaults to true.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'Openstack Messaging Service'.
#
# [*configure_user_role*]
#   (Optional) Whether to configure the admin role for the service user.
#   Defaults to true
#
class zaqar::keystone::auth (
  String[1] $password,
  $email                  = 'zaqar@localhost',
  $auth_name              = 'zaqar',
  $service_name           = 'zaqar',
  $service_type           = 'messaging',
  $public_url             = 'http://127.0.0.1:8888',
  $admin_url              = 'http://127.0.0.1:8888',
  $internal_url           = 'http://127.0.0.1:8888',
  $region                 = 'RegionOne',
  $tenant                 = 'services',
  $roles                  = ['admin'],
  $system_scope           = 'all',
  $system_roles           = [],
  $configure_endpoint     = true,
  $configure_user         = true,
  $configure_user_role    = true,
  $configure_service      = true,
  $service_description    = 'OpenStack Messaging Service',
) {
  include zaqar::deps

  Keystone::Resource::Service_identity['zaqar'] -> Anchor['zaqar::service::end']

  keystone::resource::service_identity { 'zaqar':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    configure_service   => $configure_service,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    auth_name           => $auth_name,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }
}
