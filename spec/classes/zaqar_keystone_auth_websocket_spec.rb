#
# Unit tests for zaqar::keystone::auth_websocket
#

require 'spec_helper'

describe 'zaqar::keystone::auth_websocket' do


  shared_examples_for 'zaqar::keystone::auth_websocket' do
    describe 'with default class parameters' do
      let :params do
        { :password => 'zaqar_password',
          :tenant   => 'foobar' }
      end

      it { is_expected.to contain_keystone_user('zaqar-websocket').with(
        :ensure   => 'present',
        :password => 'zaqar_password',
      ) }

      it { is_expected.to contain_keystone_user_role('zaqar-websocket@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('zaqar-websocket::messaging-websocket').with(
        :ensure      => 'present',
        :description => 'Openstack messaging websocket Service'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/zaqar-websocket::messaging-websocket').with(
        :ensure       => 'present',
        :public_url   => "ws://127.0.0.1:9000",
        :admin_url    => "ws://127.0.0.1:9000",
        :internal_url => "ws://127.0.0.1:9000"
      ) }
    end

    describe 'when overriding public_url, internal_url and admin_url' do
      let :params do
        { :password     => 'zaqar_password',
          :public_url   => 'ws://10.10.10.10:9000',
          :admin_url    => 'ws://10.10.10.10:9000',
          :internal_url => 'ws://10.10.10.10:9000'
        }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/zaqar-websocket::messaging-websocket').with(
        :ensure       => 'present',
        :public_url   => "ws://10.10.10.10:9000",
        :internal_url => "ws://10.10.10.10:9000",
        :admin_url    => "ws://10.10.10.10:9000"
      ) }
    end

    describe 'when overriding auth name' do
      let :params do
        { :password => 'foo',
          :auth_name => 'zaqary' }
      end

      it { is_expected.to contain_keystone_user('zaqary') }
      it { is_expected.to contain_keystone_user_role('zaqary@services') }
      it { is_expected.to contain_keystone_service('zaqar-websocket::messaging-websocket') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/zaqar-websocket::messaging-websocket') }
    end

    describe 'when overriding service name' do
      let :params do
        { :service_name => 'zaqar_service',
          :auth_name    => 'zaqar-websocket',
          :password     => 'zaqar_password' }
      end

      it { is_expected.to contain_keystone_user('zaqar-websocket') }
      it { is_expected.to contain_keystone_user_role('zaqar-websocket@services') }
      it { is_expected.to contain_keystone_service('zaqar_service::messaging-websocket') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/zaqar_service::messaging-websocket') }
    end

    describe 'when disabling user configuration' do

      let :params do
        {
          :password       => 'zaqar_password',
          :configure_user => false
        }
      end

      it { is_expected.not_to contain_keystone_user('zaqar-websocket') }
      it { is_expected.to contain_keystone_user_role('zaqar-websocket@services') }
      it { is_expected.to contain_keystone_service('zaqar-websocket::messaging-websocket').with(
        :ensure      => 'present',
        :description => 'Openstack messaging websocket Service'
      ) }

    end

    describe 'when disabling user and user role configuration' do

      let :params do
        {
          :password            => 'zaqar_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { is_expected.not_to contain_keystone_user('zaqar-websocket') }
      it { is_expected.not_to contain_keystone_user_role('zaqar-websocket@services') }
      it { is_expected.to contain_keystone_service('zaqar-websocket::messaging-websocket').with(
        :ensure      => 'present',
        :description => 'Openstack messaging websocket Service'
      ) }

    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'zaqar::keystone::auth_websocket'
    end
  end

end
