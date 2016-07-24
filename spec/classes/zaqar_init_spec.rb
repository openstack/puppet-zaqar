require 'spec_helper'
describe 'zaqar' do
  shared_examples 'zaqar' do
    let :req_params do
      {
        :password   => 'foo',
      }
    end

    describe 'with only required params' do
      let :params do
        req_params
      end

      it { is_expected.to contain_package('zaqar-common').with(
          :ensure => 'present',
          :name   => platform_params[:zaqar_common_package],
          :tag    => ['openstack', 'zaqar-package']
      )}

      it { is_expected.to contain_class('zaqar::params') }

      it 'should contain default config' do
        is_expected.to contain_zaqar_config('keystone_authtoken/auth_uri').with(
         :value => 'http://localhost:5000/'
        )
        is_expected.to contain_zaqar_config('keystone_authtoken/auth_url').with(
         :value => 'http://localhost:35357/'
        )
        is_expected.to contain_zaqar_config('keystone_authtoken/project_name').with(
         :value => 'services'
        )
        is_expected.to contain_zaqar_config('keystone_authtoken/username').with(
         :value => 'zaqar'
        )
        is_expected.to contain_zaqar_config('keystone_authtoken/password').with(
         :value => 'foo'
        )
        is_expected.to contain_zaqar_config('DEFAULT/auth_strategy').with(
         :value => 'keystone'
        )
        is_expected.to contain_zaqar_config('keystone_authtoken/project_domain_name').with_value('Default')
        is_expected.to contain_zaqar_config('keystone_authtoken/user_domain_name').with_value('Default')
        is_expected.to contain_zaqar_config('keystone_authtoken/auth_type').with(:value => 'password')
        is_expected.to contain_zaqar_config('keystone_authtoken/auth_version').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/auth_section').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/cache').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/check_revocations_for_cached').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/delay_auth_decision').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/enforce_token_bind').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/hash_algorithms').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/http_connect_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/http_request_max_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/include_service_catalog').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/keyfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/memcache_pool_conn_get_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/memcache_pool_dead_retry').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/memcache_pool_maxsize').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/memcache_pool_socket_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/memcache_secret_key').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/memcache_security_strategy').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/memcache_use_advanced_pool').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/memcache_pool_unused_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/memcached_servers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/revocation_cache_time').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/signing_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_zaqar_config('keystone_authtoken/token_cache_time').with_value('<SERVICE DEFAULT>')
      end

    end

    describe 'with custom values' do
      let :params do
        req_params.merge!({
          :admin_mode                     => true,
          :unreliable                     => true,
          :pooling                        => true,
          :queue_pipeline                 => 'zaqar_pipeline1',
          :message_pipeline               => 'zaqar_pipeline2',
          :claim_pipeline                 => 'zaqar_pipeline3',
          :subscription_pipeline          => 'zaqar_pipeline4',
          :max_messages_post_size         => '1234',
          :auth_uri                       => 'https://10.0.0.1:9999/',
          :username                       => 'myuser',
          :password                       => 'mypasswd',
          :auth_url                       => 'http://:127.0.0.1:35357',
          :project_name                   => 'service_project',
          :user_domain_name               => 'domainX',
          :project_domain_name            => 'domainX',
          :insecure                       => false,
          :auth_section                   => 'new_section',
          :auth_type                      => 'password',
          :auth_version                   => 'v3',
          :cache                          => 'somevalue',
          :cafile                         => '/opt/stack/data/cafile.pem',
          :certfile                       => 'certfile.crt',
          :check_revocations_for_cached   => false,
          :delay_auth_decision            => false,
          :enforce_token_bind             => 'permissive',
          :hash_algorithms                => 'md5',
          :http_connect_timeout           => '300',
          :http_request_max_retries       => '3',
          :include_service_catalog        => true,
          :keyfile                        => '',
          :memcache_pool_conn_get_timeout => '9',
          :memcache_pool_dead_retry       => '302',
          :memcache_pool_maxsize          => '11',
          :memcache_pool_socket_timeout   => '2',
          :memcache_pool_unused_timeout   => '61',
          :memcache_secret_key            => 'secret_key',
          :memcache_security_strategy     => 'ENCRYPT',
          :memcache_use_advanced_pool     => true,
          :memcached_servers              => ['memcached01:11211','memcached02:11211'],
          :region_name                    => 'region2',
          :revocation_cache_time          => '11',
          :signing_dir                    => '/var/cache',
          :token_cache_time               => '301',
        })
      end

      it do
        is_expected.to contain_zaqar_config('DEFAULT/admin_mode').with_value(true)
        is_expected.to contain_zaqar_config('DEFAULT/unreliable').with_value(true)
        is_expected.to contain_zaqar_config('DEFAULT/pooling').with_value(true)
        is_expected.to contain_zaqar_config('storage/queue_pipeline').with_value('zaqar_pipeline1')
        is_expected.to contain_zaqar_config('storage/message_pipeline').with_value('zaqar_pipeline2')
        is_expected.to contain_zaqar_config('storage/claim_pipeline').with_value('zaqar_pipeline3')
        is_expected.to contain_zaqar_config('storage/subscription_pipeline').with_value('zaqar_pipeline4')
        is_expected.to contain_zaqar_config('transport/max_messages_post_size').with_value('1234')
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/auth_uri').with_value('https://10.0.0.1:9999/')
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/username').with_value(params[:username])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/password').with_value(params[:password]).with_secret(true)
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/auth_url').with_value(params[:auth_url])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/project_name').with_value(params[:project_name])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/user_domain_name').with_value(params[:user_domain_name])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/project_domain_name').with_value(params[:project_domain_name])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/insecure').with_value(params[:insecure])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/auth_section').with_value(params[:auth_section])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/auth_type').with_value(params[:auth_type])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/cache').with_value(params[:cache])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/cafile').with_value(params[:cafile])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/certfile').with_value(params[:certfile])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/check_revocations_for_cached').with_value(params[:check_revocations_for_cached])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/delay_auth_decision').with_value(params[:delay_auth_decision])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/enforce_token_bind').with_value(params[:enforce_token_bind])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/hash_algorithms').with_value(params[:hash_algorithms])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/http_connect_timeout').with_value(params[:http_connect_timeout])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/http_request_max_retries').with_value(params[:http_request_max_retries])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/include_service_catalog').with_value(params[:include_service_catalog])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/keyfile').with_value(params[:keyfile])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/memcache_pool_conn_get_timeout').with_value(params[:memcache_pool_conn_get_timeout])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/memcache_pool_dead_retry').with_value(params[:memcache_pool_dead_retry])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/memcache_pool_maxsize').with_value(params[:memcache_pool_maxsize])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/memcache_pool_socket_timeout').with_value(params[:memcache_pool_socket_timeout])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/memcache_secret_key').with_value(params[:memcache_secret_key])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/memcache_security_strategy').with_value(params[:memcache_security_strategy])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/memcache_use_advanced_pool').with_value(params[:memcache_use_advanced_pool])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/memcached_servers').with_value('memcached01:11211,memcached02:11211')
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/region_name').with_value(params[:region_name])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/revocation_cache_time').with_value(params[:revocation_cache_time])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/signing_dir').with_value(params[:signing_dir])
        is_expected.to contain_zaqar_config(
          'keystone_authtoken/token_cache_time').with_value(params[:token_cache_time])
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
        case facts[:osfamily]
        when 'Debian'
          { :zaqar_common_package => 'zaqar' }
        when 'RedHat'
          { :zaqar_common_package => 'openstack-zaqar' }
        end
      end
      it_behaves_like 'zaqar'
    end
  end
end
