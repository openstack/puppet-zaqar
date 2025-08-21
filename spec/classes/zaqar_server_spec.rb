require 'spec_helper'
describe 'zaqar::server' do

  shared_examples_for 'zaqar::server' do
    let :pre_condition do
      "class { 'zaqar::keystone::authtoken':
         password => 'foo',
       }
      class { 'zaqar::keystone::trust':
         password => 'foo',
       }
       class { 'zaqar': }
       class { 'apache': }"
    end

    context 'with defaults' do
      it { is_expected.to contain_service('zaqar-server').with(
        :ensure => 'running',
        :name   => platform_params[:zaqar_service_name],
        :enable => true,
        :tag    => ['zaqar-service'],
      )}
      it { is_expected.to contain_class('zaqar::policy') }
    end

    context 'when running zaqar-server in wsgi' do
      let :params do
        { :service_name => 'httpd' }
      end

      it { is_expected.to contain_service('zaqar-server').with(
        :ensure => 'stopped',
        :name   => platform_params[:zaqar_service_name],
        :enable => false,
        :tag    => ['zaqar-service'],
      )}
    end

    context 'with service management disabled' do
      let :params do
        { :manage_service => false }
      end

      it { is_expected.to_not contain_service('zaqar-server') }
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

      it_configures 'zaqar::server'
    end
  end
end
