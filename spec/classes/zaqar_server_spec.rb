require 'spec_helper'
describe 'zaqar::server' do

  shared_examples_for 'zaqar::server' do
    describe 'with a zaqar server enabled' do
      let :pre_condition do
        "class { '::zaqar::keystone::authtoken':
           password =>'foo',
         }
         class {'::zaqar': }"
      end

      it { is_expected.to contain_service(platform_params[:zaqar_service_name]).with(
          :ensure => 'running',
          :enable => true
      )}
      it { is_expected.to contain_class('zaqar::policy') }

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
        case facts[:osfamily]
        when 'Debian'
          { :zaqar_service_name => 'zaqar-server' }
        when 'RedHat'
          { :zaqar_service_name => 'openstack-zaqar' }
        end
      end

      it_configures 'zaqar::server'
    end
  end
end
