# == class: zaqar::transport::wsgi
#
# [*bind*]
#   Address on which the self-hosting server will listen.
#   Defaults to $facts['os_service_default'].
#
# [*port*]
#   Port on which the self-hosting server will listen.
#   Defaults to $facts['os_service_default'].
#
class zaqar::transport::wsgi(
  $bind = $facts['os_service_default'],
  $port = $facts['os_service_default'],
) {

  include zaqar::deps

  zaqar_config {
    'drivers:transport:wsgi/bind': value => $bind;
    'drivers:transport:wsgi/port': value => $port;
  }

}
