require 'spec_helper'

describe 'zaqar::messaging::redis' do

  shared_examples_for 'zaqar::messaging::redis' do
    let :pre_condition do
      "class { '::zaqar::keystone::authtoken':
         password =>'foo',
       }
       class { '::zaqar':
         message_store =>'redis',
       }"

    end
    let :req_params do
      {
        :uri   => 'redis://127.0.0.1:6379',
      }
    end

    describe 'with only required params' do
      let :params do
        req_params
      end

      it 'should config redis messaging driver' do
        is_expected.to contain_zaqar_config('drivers/message_store').with(
         :value => 'redis'
        )
        is_expected.to contain_zaqar_config('drivers:message_store:redis/uri').with(
         :value => 'redis://127.0.0.1:6379'
        )
      end

    end

    describe 'with custom values' do
      let :params do
        req_params.merge!({
          :max_reconnect_attempts => '4',
          :reconnect_sleep => '5',
        })
      end

      it 'configures custom values' do
        is_expected.to contain_zaqar_config('drivers:message_store:redis/max_reconnect_attempts').with_value('4')
        is_expected.to contain_zaqar_config('drivers:message_store:redis/reconnect_sleep').with_value('5')
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

      it_configures 'zaqar::messaging::redis'
    end
  end
end

