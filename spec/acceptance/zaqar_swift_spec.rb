require 'spec_helper_acceptance'

describe 'swift zaqar' do

  context 'default parameters' do

    it 'zaqar with swift should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone
      include ::openstack_integration::swift

      class { '::memcached':
        listen_ip => '127.0.0.1',
      }

      class { '::zaqar::keystone::auth':
        password => 'a_big_secret',
      }

      class { '::zaqar::keystone::auth_websocket':
        password => 'a_big_secret',
      }

      class {'::zaqar::management::sqlalchemy':
        uri => 'mysql+pymysql://zaqar:a_big_secret@127.0.0.1/zaqar?charset=utf8',
      }
      class {'::zaqar::messaging::swift':
        uri => 'swift://zaqar:a_big_secret:/service'
      }
      class {'::zaqar::keystone::authtoken':
        password => 'a_big_secret',
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

