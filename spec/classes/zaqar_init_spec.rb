require 'spec_helper'
describe 'zaqar' do
  shared_examples 'zaqar' do
    let :req_params do
      {
        :admin_password => 'foo',
      }
    end

    describe 'with only required params' do
      let :params do
        req_params
      end

      it { is_expected.to contain_package('zaqar-common').with(
          :ensure => 'present',
          :name   => platform_params[:zaqar_common_package],
          :tag    => ['openstack', 'zaqar-package']
      )}

      it { is_expected.to contain_class('zaqar::params') }

      it 'should contain default config' do
        is_expected.to contain_zaqar_config('DEFAULT/auth_strategy').with(
         :value => 'keystone'
        )
      end

    end

    describe 'with deprecated parameters set' do
      let :params do
        req_params.delete(:admin_password)
        req_params.merge!({
          'identity_uri'      => 'https://localhost:35357/deprecated',
          'auth_uri'          => 'https://localhost:5000/deprecated',
          'admin_user'        => 'dummy',
          'admin_password'    => 'mypassword',
          'admin_tenant_name' => 'mytenant',
        })
      end

      it 'configures authtoken section' do
        is_expected.to contain_zaqar_config('keystone_authtoken/auth_url').with(:value => 'https://localhost:35357/deprecated')
        is_expected.to contain_zaqar_config('keystone_authtoken/auth_uri').with(:value => 'https://localhost:5000/deprecated')
        is_expected.to contain_zaqar_config('keystone_authtoken/username').with(:value => 'dummy')
        is_expected.to contain_zaqar_config('keystone_authtoken/password').with(:value => 'mypassword')
        is_expected.to contain_zaqar_config('keystone_authtoken/project_name').with(:value => 'mytenant')
      end
    end

    describe 'with custom values' do
      let :params do
        req_params.merge!({
          :admin_mode                     => true,
          :unreliable                     => true,
          :pooling                        => true,
          :queue_pipeline                 => 'zaqar_pipeline1',
          :message_pipeline               => 'zaqar_pipeline2',
          :claim_pipeline                 => 'zaqar_pipeline3',
          :subscription_pipeline          => 'zaqar_pipeline4',
          :max_messages_post_size         => '1234',
        })
      end

      it do
        is_expected.to contain_zaqar_config('DEFAULT/admin_mode').with_value(true)
        is_expected.to contain_zaqar_config('DEFAULT/unreliable').with_value(true)
        is_expected.to contain_zaqar_config('DEFAULT/pooling').with_value(true)
        is_expected.to contain_zaqar_config('storage/queue_pipeline').with_value('zaqar_pipeline1')
        is_expected.to contain_zaqar_config('storage/message_pipeline').with_value('zaqar_pipeline2')
        is_expected.to contain_zaqar_config('storage/claim_pipeline').with_value('zaqar_pipeline3')
        is_expected.to contain_zaqar_config('storage/subscription_pipeline').with_value('zaqar_pipeline4')
        is_expected.to contain_zaqar_config('transport/max_messages_post_size').with_value('1234')
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
        case facts[:osfamily]
        when 'Debian'
          { :zaqar_common_package => 'zaqar' }
        when 'RedHat'
          { :zaqar_common_package => 'openstack-zaqar' }
        end
      end
      it_behaves_like 'zaqar'
    end
  end
end
