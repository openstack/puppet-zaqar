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
        case facts[:osfamily]
        when 'Debian'
          { :client_package_name => 'python3-zaqarclient' }
        when 'RedHat'
          if facts[:operatingsystem] == 'Fedora'
            { :client_package_name => 'python3-zaqarclient' }
          else
            if facts[:operatingsystemmajrelease] > '7'
              { :client_package_name => 'python3-zaqarclient' }
            else
              { :client_package_name => 'python-zaqarclient' }
            end
          end
        end
      end

      it_behaves_like 'zaqar client'
    end
  end

end
