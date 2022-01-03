#
# Unit tests for zaqar::keystone::auth
#

require 'spec_helper'

describe 'zaqar::keystone::auth' do
  shared_examples_for 'zaqar::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'zaqar_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('zaqar').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'zaqar',
        :service_type        => 'messaging',
        :service_description => 'OpenStack Messaging Service',
        :region              => 'RegionOne',
        :auth_name           => 'zaqar',
        :password            => 'zaqar_password',
        :email               => 'zaqar@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:8888',
        :internal_url        => 'http://127.0.0.1:8888',
        :admin_url           => 'http://127.0.0.1:8888',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'zaqar_password',
          :auth_name           => 'alt_zaqar',
          :email               => 'alt_zaqar@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin', 'service'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative OpenStack Messaging Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_messaging',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('zaqar').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_messaging',
        :service_description => 'Alternative OpenStack Messaging Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_zaqar',
        :password            => 'zaqar_password',
        :email               => 'alt_zaqar@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
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

      it_behaves_like 'zaqar::keystone::auth'
    end
  end
end
