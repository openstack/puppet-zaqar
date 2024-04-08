require 'spec_helper'

describe 'zaqar::management::redis' do

  shared_examples_for 'zaqar::management::redis' do
    let :pre_condition do
      "class { 'zaqar::keystone::authtoken':
         password => 'foo',
       }
       class { 'zaqar::keystone::trust':
         password => 'foo',
       }
       class { 'zaqar':
         management_store =>'redis',
       }"

    end
    let :req_params do
      {
        :uri => 'redis://127.0.0.1:6379',
      }
    end

    describe 'with only required params' do
      let :params do
        req_params
      end

      it 'should config redis management driver' do
        is_expected.to contain_zaqar_config('drivers/management_store').with_value('redis')
        is_expected.to contain_zaqar_config('drivers:management_store:redis/uri').with_value('redis://127.0.0.1:6379')
        is_expected.to contain_zaqar_config('drivers:management_store:redis/max_reconnect_attempts').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('drivers:management_store:redis/reconnect_sleep').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_package('python-redis').with(
          :ensure => 'installed',
          :name   => platform_params[:python_redis_package_name],
          :tag    => ['openstack'],
        )
      end

    end

    describe 'with custom values' do
      let :params do
        req_params.merge!({
          :max_reconnect_attempts => 10,
          :reconnect_sleep        => 1,
        })
      end

      it 'configures custom values' do
        is_expected.to contain_zaqar_config('drivers:management_store:redis/max_reconnect_attempts').with_value(10)
        is_expected.to contain_zaqar_config('drivers:management_store:redis/reconnect_sleep').with_value(1)
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
          {
            :python_redis_package_name => 'python3-redis',
          }
        when 'RedHat'
          {
            :python_redis_package_name => 'python3-redis',
          }
        end
      end

      it_configures 'zaqar::management::redis'
    end
  end

end
