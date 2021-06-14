# == Class: zaqar::params
#
# Parameters for puppet-zaqar
#
class zaqar::params {
  include openstacklib::defaults

  $pyver3 = $::openstacklib::defaults::pyver3

  $client_package_name = 'python3-zaqarclient'
  $group               = 'zaqar'

  case $::osfamily {
    'RedHat': {
      $package_name             = 'openstack-zaqar'
      $service_name             = 'openstack-zaqar'
      $zaqar_wsgi_script_source = "/usr/lib/python${pyver3}/site-packages/zaqar/transport/wsgi/app.py"
      $zaqar_wsgi_script_path   = '/var/www/cgi-bin/zaqar'
    }
    'Debian': {
      $package_name             = 'zaqar-server'
      $service_name             = 'zaqar-server'
      $zaqar_wsgi_script_source = "/usr/lib/python${pyver3}/dist-packages/zaqar/transport/wsgi/app.py"
      $zaqar_wsgi_script_path   = '/usr/lib/cgi-bin/zaqar'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: \
      ${::operatingsystem}, module ${module_name} only support osfamily \
      RedHat and Debian")
    }
  }
}
