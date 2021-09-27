#
# Unit tests for zaqar::keystone::auth_websocket
#

require 'spec_helper'

describe 'zaqar::keystone::auth_websocket' do
  shared_examples_for 'zaqar::keystone::auth_websocket' do
    context 'with default class parameters' do
      let :params do
        { :password => 'zaqar-websocket_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('zaqar-websocket').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'zaqar-websocket',
        :service_type        => 'messaging-websocket',
        :service_description => 'Openstack messaging websocket Service',
        :region              => 'RegionOne',
        :auth_name           => 'zaqar-websocket',
        :password            => 'zaqar-websocket_password',
        :email               => 'zaqar-websocket@localhost',
        :tenant              => 'services',
        :public_url          => 'ws://127.0.0.1:9000',
        :internal_url        => 'ws://127.0.0.1:9000',
        :admin_url           => 'ws://127.0.0.1:9000',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'zaqar-websocket_password',
          :auth_name           => 'alt_zaqar-websocket',
          :email               => 'alt_zaqar-websocket@alt_localhost',
          :tenant              => 'alt_service',
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative Openstack messaging websocket Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_messaging-websocket',
          :region              => 'RegionTwo',
          :public_url          => 'wss://10.10.10.10:80',
          :internal_url        => 'ws://10.10.10.11:81',
          :admin_url           => 'ws://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('zaqar-websocket').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_messaging-websocket',
        :service_description => 'Alternative Openstack messaging websocket Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_zaqar-websocket',
        :password            => 'zaqar-websocket_password',
        :email               => 'alt_zaqar-websocket@alt_localhost',
        :tenant              => 'alt_service',
        :public_url          => 'wss://10.10.10.10:80',
        :internal_url        => 'ws://10.10.10.11:81',
        :admin_url           => 'ws://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'zaqar::keystone::auth_websocket'
    end
  end
end
