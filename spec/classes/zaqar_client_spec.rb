require 'spec_helper'

describe 'zaqar::client' do

  shared_examples_for 'zaqar client' do

    it { is_expected.to contain_class('zaqar::deps') }
    it { is_expected.to contain_class('zaqar::params') }

    it 'installs zaqar client package' do
      is_expected.to contain_package('python-zaqarclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
      )
    end

    it { is_expected.to contain_class('openstacklib::openstackclient') }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :client_package_name => 'python3-zaqarclient' }
        when 'RedHat'
          { :client_package_name => 'python3-zaqarclient' }
        end
      end

      it_behaves_like 'zaqar client'
    end
  end

end
