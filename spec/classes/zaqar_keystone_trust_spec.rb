require 'spec_helper'

describe 'zaqar::keystone::trust' do

  shared_examples_for 'zaqar::keystone::trust' do
    let :params do
      { :password => 'secret' }
    end

    context 'with default values' do
      it 'configures default values' do
        is_expected.to contain_zaqar_config('trustee/username').with_value('zaqar')
        is_expected.to contain_zaqar_config('trustee/password').with_value('secret').with_secret(true)
        is_expected.to contain_zaqar_config('trustee/auth_url').with_value('http://localhost:5000')
        is_expected.to contain_zaqar_config('trustee/user_domain_name').with_value('Default')
        is_expected.to contain_zaqar_config('trustee/auth_section').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('trustee/auth_type').with_value('password')
      end
    end

    context 'with custom values' do
      before :each do
        params.merge!({
          :username         => 'user',
          :password         => 'secret',
          :auth_url         => 'http://there',
          :user_domain_name => 'domain',
          :auth_section     => 'keystone',
          :auth_type        => 'token',
        })
      end

      it 'configures custom values' do
        is_expected.to contain_zaqar_config('trustee/username').with_value('user')
        is_expected.to contain_zaqar_config('trustee/password').with_value('secret').with_secret(true)
        is_expected.to contain_zaqar_config('trustee/auth_url').with_value('http://there')
        is_expected.to contain_zaqar_config('trustee/user_domain_name').with_value('domain')
        is_expected.to contain_zaqar_config('trustee/auth_section').with_value('keystone')
        is_expected.to contain_zaqar_config('trustee/auth_type').with_value('token')
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

      it_configures 'zaqar::keystone::trust'
    end
  end
end

