# == Class: zaqar::params
#
# Parameters for puppet-zaqar
#
class zaqar::params {
  include openstacklib::defaults

  $pyver3 = $::openstacklib::defaults::pyver3

  $client_package_name = 'python3-zaqarclient'
  $user                = 'zaqar'
  $group               = 'zaqar'

  case $facts['os']['family'] {
    'RedHat': {
      $package_name             = 'openstack-zaqar'
      $service_name             = 'openstack-zaqar'
      $zaqar_wsgi_script_source = "/usr/lib/python${pyver3}/site-packages/zaqar/transport/wsgi/app.py"
      $zaqar_wsgi_script_path   = '/var/www/cgi-bin/zaqar'
    }
    'Debian': {
      $package_name             = 'zaqar-server'
      $service_name             = 'zaqar-server'
      $zaqar_wsgi_script_source = '/usr/lib/python3/dist-packages/zaqar/transport/wsgi/app.py'
      $zaqar_wsgi_script_path   = '/usr/lib/cgi-bin/zaqar'
    }
    default: {
      fail("Unsupported osfamily: ${facts['os']['family']}")
    }
  }
}
