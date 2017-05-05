require 'spec_helper_acceptance'

describe 'basic zaqar' do

  context 'default parameters' do

    it 'zaqar with mongo should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      class { '::zaqar::keystone::auth':
        password => 'a_big_secret',
      }

      class { '::zaqar::keystone::auth_websocket':
        password => 'a_big_secret',
      }

      include ::mongodb::globals
      include ::mongodb::client
      class { '::mongodb::server':
        replset         => 'zaqar',
        replset_members => ['127.0.0.1:27017'],
        dbpath_fix      => false,
      }
      $zaqar_mongodb_conn_string = 'mongodb://127.0.0.1:27017'

      Mongodb_replset['zaqar'] -> Package['zaqar-common']

      class {'::zaqar::management::mongodb':
        uri => $zaqar_mongodb_conn_string
      }
      class {'::zaqar::messaging::mongodb':
        uri => $zaqar_mongodb_conn_string
      }
      class {'::zaqar::keystone::authtoken':
        password => 'a_big_secret',
      }
      class {'::zaqar::logging':
        debug => true,
      }
      class {'::zaqar':
        unreliable => true,
      }
      class {'::zaqar::server':
        service_name => 'httpd',
      }
      include ::apache
      class { '::zaqar::wsgi::apache':
        ssl => false,
      }
      # run a second instance using websockets, the Debian system does
      # not support the use of services to run a second instance.
      if $::osfamily == 'RedHat' {
        zaqar::server_instance{ '1':
          transport => 'websocket'
        }
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(8888) do
      it { is_expected.to be_listening }
    end

  end

end
