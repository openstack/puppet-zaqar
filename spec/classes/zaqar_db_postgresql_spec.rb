require 'spec_helper'

describe 'zaqar::db::postgresql' do

  shared_examples_for 'zaqar::db::postgresql' do
    let :req_params do
      { :password => 'zaqarpass' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('zaqar::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('zaqar').with(
        :user       => 'zaqar',
        :password   => 'zaqarpass',
        :dbname     => 'zaqar',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          # puppet-postgresql requires the service_provider fact provided by
          # puppetlabs-postgresql.
          :service_provider => 'systemd'
        }))
      end

      it_configures 'zaqar::db::postgresql'
    end
  end

end
