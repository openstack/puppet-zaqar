require 'spec_helper'

describe 'zaqar::messaging::swift' do

  shared_examples_for 'zaqar::messaging::swift' do
    let :pre_condition do
      "class { 'zaqar::keystone::authtoken':
         password => 'foo',
       }
       class { 'zaqar::keystone::trust':
         password => 'foo',
       }
       class { 'zaqar':
         message_store =>'swift',
       }"
    end
    let :req_params do
      {
        :uri => 'swift://user:pass@/zaqar',
      }
    end

    describe 'with only required params' do
      let :params do
        req_params
      end

      it 'should config swift messaging driver' do
        is_expected.to contain_zaqar_config('drivers/message_store').with_value('swift')
        is_expected.to contain_zaqar_config('drivers:message_store:swift/uri').with_value(
          'swift://user:pass@/zaqar',
        ).with_secret(true)
        is_expected.to contain_zaqar_config('drivers:message_store:swift/auth_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('drivers:message_store:swift/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('drivers:message_store:swift/user_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('drivers:message_store:swift/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('drivers:message_store:swift/interface').with_value('<SERVICE DEFAULT>')
      end

    end

    describe 'with custom values' do
      let :params do
        req_params.merge!({
          :auth_url            => 'http://foo',
          :project_domain_name => 'Domain1',
          :user_domain_name    => 'Domain2',
          :region_name         => 'regionOne',
          :interface           => 'publicURL',
        })
      end

      it 'configures custom values' do
        is_expected.to contain_zaqar_config('drivers:message_store:swift/auth_url').with_value('http://foo')
        is_expected.to contain_zaqar_config('drivers:message_store:swift/project_domain_name').with_value('Domain1')
        is_expected.to contain_zaqar_config('drivers:message_store:swift/user_domain_name').with_value('Domain2')
        is_expected.to contain_zaqar_config('drivers:message_store:swift/region_name').with_value('regionOne')
        is_expected.to contain_zaqar_config('drivers:message_store:swift/interface').with_value('publicURL')
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

