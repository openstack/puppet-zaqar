require 'spec_helper'
describe 'zaqar::server_instance' do

  shared_examples_for 'zaqar::server_instance' do
    describe 'zaqar::server_instance' do
      let :title do
        '1'
      end

      let :pre_condition do
        "class { 'zaqar::keystone::authtoken':
           password => 'foo',
         }
         class { 'zaqar::keystone::trust':
           password => 'foo',
         }
         class { 'zaqar': }"
      end

      let :params do
        {
          :transport => 'websocket'
        }
      end

      context 'with a websocket server instance 1' do
        it { is_expected.to contain_service("#{platform_params[:zaqar_service_name]}@1").with(
            :ensure => 'running',
            :enable => true
        )}
        it { is_expected.to contain_file('/etc/zaqar/1.conf') }
      end

      context 'with the name not allowed' do
        let :title do
          'zaqar'
        end

        it { is_expected.to raise_error(Puppet::Error) }
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :zaqar_service_name => 'zaqar-server' }
        when 'RedHat'
          { :zaqar_service_name => 'openstack-zaqar' }
        end
      end

      it_configures 'zaqar::server_instance'
    end
  end
end
