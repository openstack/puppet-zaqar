require 'spec_helper'

describe 'zaqar::signed_url' do
  shared_examples 'zaqar::signed_url' do
    let :params do
      {
        :secret_key => 'key'
      }
    end

    context 'with defaults' do
      it 'should configure defaults' do
        is_expected.to contain_zaqar_config('signed_url/secret_key').with_value('key').with_secret(true)
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'zaqar::signed_url'
    end
  end
end
