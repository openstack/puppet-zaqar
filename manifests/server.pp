# = Class: zaqar::server
#
# This class manages the Zaqar server.
#
# [*enabled*]
#   (Optional) Service enable state for zaqar-server.
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether the service is managed by this puppet class.
#   Defaults to true.
#
#  [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of zaqar-server
#   If the value is 'httpd', this means zaqar-server will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'zaqar::wsgi::apache'...}
#   to make zaqar-server be a web app using apache mod_wsgi.
#   Defaults to '$zaqar::params::service_name'
#
class zaqar::server (
  Boolean $manage_service = true,
  Boolean $enabled        = true,
  String[1] $service_name = $zaqar::params::service_name,
) inherits zaqar::params {
  include zaqar
  include zaqar::deps
  include zaqar::policy

  if $manage_service {
    case $service_name {
      'httpd': {
        Service <| title == 'httpd' |> { tag +> 'zaqar-service' }

        service { 'zaqar-server':
          ensure => 'stopped',
          name   => $zaqar::params::service_name,
          enable => false,
          tag    => ['zaqar-service'],
        }

        # we need to make sure zaqar-server is stopped before trying to start apache
        Service['zaqar-server'] -> Service['httpd']
      }
      default: {
        $service_ensure = $enabled ? {
          true    => 'running',
          default => 'stopped',
        }

        service { 'zaqar-server':
          ensure    => $service_ensure,
          name      => $service_name,
          enable    => $enabled,
          hasstatus => true,
          tag       => 'zaqar-service',
        }
      }
    }
  }
}
