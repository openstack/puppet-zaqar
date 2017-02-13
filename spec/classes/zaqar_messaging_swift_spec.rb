require 'spec_helper'

describe 'zaqar::messaging::swift' do

  shared_examples_for 'zaqar::messaging::swift' do
    let :pre_condition do
      "class { '::zaqar::keystone::authtoken':
         password =>'foo',
       }
       class { '::zaqar':
         message_store =>'swift',
       }"
    end
    let :req_params do
      {
        :uri   => 'swift://user:pass@/zaqar',
      }
    end

    describe 'with only required params' do
      let :params do
        req_params
      end

      it 'should config swift messaging driver' do
        is_expected.to contain_zaqar_config('drivers/message_store').with(
         :value => 'swift'
        )
        is_expected.to contain_zaqar_config('drivers:message_store:swift/uri').with(
         :value => 'swift://user:pass@/zaqar',
        )
      end

    end

    describe 'with custom values' do
      let :params do
        req_params.merge!({
          :auth_url  => 'http://foo',
        })
      end

      it 'configures custom values' do
        is_expected.to contain_zaqar_config('drivers:message_store:swift/auth_url').with_value('http://foo')
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

      it_configures 'zaqar::messaging::swift'
    end
  end
end

