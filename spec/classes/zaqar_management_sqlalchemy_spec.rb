require 'spec_helper'

describe 'zaqar::management::sqlalchemy' do

  shared_examples_for 'zaqar::management::sqlalchemy' do
    let :pre_condition do
      "class { 'zaqar::keystone::authtoken':
         password => 'foo',
       }
       class { 'zaqar::keystone::trust':
         password => 'foo',
       }
       class { 'zaqar':
         management_store =>'sqlalchemy',
       }"

    end
    let :req_params do
      {
        :uri   => 'mysql://user:pass@127.0.0.1/zaqar',
      }
    end

    describe 'with only required params' do
      let :params do
        req_params
      end

      it 'should config sqlalchemy management driver' do
        is_expected.to contain_zaqar_config('drivers/management_store').with(
         :value => 'sqlalchemy'
        )
        is_expected.to contain_zaqar_config('drivers:management_store:sqlalchemy/uri').with(
         :value => 'mysql://user:pass@127.0.0.1/zaqar',
        )
        is_expected.to contain_oslo__db('zaqar_config').with(
          :connection             => 'mysql://user:pass@127.0.0.1/zaqar',
          :backend_package_ensure => 'present'
        )
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

      it_configures 'zaqar::management::sqlalchemy'
    end
  end

end

