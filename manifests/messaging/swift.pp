# == class: zaqar::messaging::swift
#
# [*uri*]
#   (Required) Swift Connection URI.
#
# [*auth_url*]
#   (Optional) URL to the KeyStone service.
#   Default $facts['os_service_default']
#
# [*project_domain_name*]
#   (Optional) Project's domain name.
#   Default $facts['os_service_default']
#
# [*user_domain_name*]
#   (Optional) User's domain name.
#   Default $facts['os_service_default']
#
# [*region_name*]
#   (Optional) Region name.
#   Default $facts['os_service_default']
#
# [*interface*]
#   (Optional) The default interface for endpoint URL discovery.
#   Default $facts['os_service_default']
#
class zaqar::messaging::swift (
  $uri,
  $auth_url            = $facts['os_service_default'],
  $project_domain_name = $facts['os_service_default'],
  $user_domain_name    = $facts['os_service_default'],
  $region_name         = $facts['os_service_default'],
  $interface           = $facts['os_service_default'],
) {
  include zaqar::deps

  zaqar_config {
    'drivers:message_store:swift/uri':                 value => $uri, secret => true;
    'drivers:message_store:swift/auth_url':            value => $auth_url;
    'drivers:message_store:swift/project_domain_name': value => $project_domain_name;
    'drivers:message_store:swift/user_domain_name':    value => $user_domain_name;
    'drivers:message_store:swift/region_name':         value => $region_name;
    'drivers:message_store:swift/interface':           value => $interface;
  }
}
