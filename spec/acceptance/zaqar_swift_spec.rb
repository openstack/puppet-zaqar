require 'spec_helper_acceptance'

describe 'swift zaqar' do

  context 'default parameters' do

    it 'zaqar with swift should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone
      include ::openstack_integration::swift
      include ::openstack_integration::memcached
      include ::openstack_integration::zaqar
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(8888) do
      it { is_expected.to be_listening }
    end

  end

end
