# == Class: zaqar::params
#
# Parameters for puppet-zaqar
#
class zaqar::params {
  include ::openstacklib::defaults

  $client_package = 'python-zaqarclient'

  case $::osfamily {
    'RedHat': {
      $package_name = 'openstack-zaqar'
      $service_name = 'openstack-zaqar'
    }
    'Debian': {
      $package_name = 'zaqar-server'
      $service_name = 'zaqar-server'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: \
      ${::operatingsystem}, module ${module_name} only support osfamily \
      RedHat and Debian")
    }
  }
}
