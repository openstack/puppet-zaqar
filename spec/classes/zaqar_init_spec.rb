require 'spec_helper'
describe 'zaqar' do
  shared_examples 'zaqar' do
    let :pre_condition do
      "class { 'zaqar::keystone::authtoken':
         password =>'password',
       }"
    end
    let :req_params do
      {}
    end

    describe 'with only required params' do
      let :params do
        req_params.merge!(:purge_config => false)
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('zaqar_config').with({
          :purge => false
        })
      end

      it { is_expected.to contain_package('zaqar-common').with(
          :ensure => 'present',
          :name   => platform_params[:zaqar_common_package],
          :tag    => ['openstack', 'zaqar-package']
      )}

      it { is_expected.to contain_class('zaqar::deps') }
      it { is_expected.to contain_class('zaqar::params') }

      it 'should contain default config' do
        is_expected.to contain_zaqar_config('DEFAULT/auth_strategy').with(
         :value => 'keystone'
        )
        is_expected.to contain_zaqar_config('storage/queue_pipeline').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('storage/message_pipeline').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('storage/claim_pipeline').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('storage/subscription_pipeline').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('storage/topic_pipeline').with_value('<SERVICE DEFAULT>')
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
          :topic_pipeline                 => 'zaqar_pipeline5',
          :max_messages_post_size         => '1234',
          :message_store                  => 'swift',
          :management_store               => 'sqlalchemy',
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
        is_expected.to contain_zaqar_config('storage/topic_pipeline').with_value('zaqar_pipeline5')
        is_expected.to contain_zaqar_config('transport/max_messages_post_size').with_value('1234')
        is_expected.to contain_zaqar_config('drivers/message_store').with_value('swift')
        is_expected.to contain_zaqar_config('drivers/management_store').with_value('sqlalchemy')
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
          { :zaqar_common_package => 'zaqar-server' }
        when 'RedHat'
          { :zaqar_common_package => 'openstack-zaqar' }
        end
      end
      it_behaves_like 'zaqar'
    end
  end
end
