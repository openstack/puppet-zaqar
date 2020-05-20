require 'spec_helper'

describe 'zaqar::db::mysql' do

  shared_examples_for 'zaqar::db::mysql' do
    let :pre_condition do
      [
        'include mysql::server',
        'include zaqar::db::sync'
      ]
    end

    let :params do
      {
        'password'  => 'zaqarpass',
      }
    end

    describe 'with only required params' do
      it { is_expected.to contain_openstacklib__db__mysql('zaqar').with(
        'user'     => 'zaqar',
        'password' => 'zaqarpass',
        'dbname'   => 'zaqar',
        'host'     => '127.0.0.1',
        'charset'  => 'utf8',
        :collate   => 'utf8_general_ci',
      )}
    end

    describe "overriding allowed_hosts param to array" do
      let :params do
        {
          :password       => 'zaqarpass',
          :allowed_hosts  => ['127.0.0.1','%']
        }
      end

    end
    describe "overriding allowed_hosts param to string" do
      let :params do
        {
          :password       => 'zaqarpass2',
          :allowed_hosts  => '192.168.1.1'
        }
      end

    end

    describe "overriding allowed_hosts param equals to host param " do
      let :params do
        {
          :password       => 'zaqarpass2',
          :allowed_hosts  => '127.0.0.1'
        }
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

      it_configures 'zaqar::db::mysql'
    end
  end

end
