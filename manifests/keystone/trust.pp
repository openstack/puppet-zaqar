# == Class: zaqar::keystone::trust
#
# Configures zaqar trust notifier.
#
# === Parameters
#
# [*password*]
#   (Required) Password of the trust user
#
# [*username*]
#   (Optional) The name of the trust user
#   Defaults to 'zaqar'
#
# [*auth_url*]
#   (Optional) The URL to use for authentication.
#   Defaults to 'http://localhost:5000'
#
# [*user_domain_name*]
#   (Optional) Name of domain for $username
#   Defaults to 'Default'
#
# [*auth_section*]
#   (Optional) Config Section from which to load plugin specific options
#   Defaults to $facts['os_service_default'].
#
# [*auth_type*]
#   (Optional) Authentication type to load
#   Defaults to 'password'
#
class zaqar::keystone::trust(
  $password,
  $username         = 'zaqar',
  $auth_url         = 'http://localhost:5000',
  $user_domain_name = 'Default',
  $auth_section     = $facts['os_service_default'],
  $auth_type        = 'password',
) {

  include zaqar::deps

  zaqar_config {
    'trustee/username':         value => $username;
    'trustee/password':         value => $password, secret =>true;
    'trustee/user_domain_name': value => $user_domain_name;
    'trustee/auth_url':         value => $auth_url;
    'trustee/auth_section':     value => $auth_section;
    'trustee/auth_type':        value => $auth_type;
  }

}
