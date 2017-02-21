require 'spec_helper'

describe 'zaqar::wsgi::apache' do

  shared_examples_for 'apache serving zaqar with mod_wsgi' do
    it { is_expected.to contain_service('httpd').with_name(platform_params[:httpd_service_name]) }
    it { is_expected.to contain_class('zaqar::params') }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_class('apache::mod::wsgi') }

    describe 'with default parameters' do

      it { is_expected.to contain_file("#{platform_params[:wsgi_script_path]}").with(
        'ensure'  => 'directory',
        'owner'   => 'zaqar',
        'group'   => 'zaqar',
        'require' => 'Package[httpd]'
      )}


      it { is_expected.to contain_file('zaqar_wsgi').with(
        'ensure'  => 'file',
        'path'    => "#{platform_params[:wsgi_script_path]}/zaqar-server",
        'source'  => platform_params[:wsgi_script_source],
        'owner'   => 'zaqar',
        'group'   => 'zaqar',
        'mode'    => '0644'
      )}
      it { is_expected.to contain_file('zaqar_wsgi').that_requires("File[#{platform_params[:wsgi_script_path]}]") }

      it { is_expected.to contain_apache__vhost('zaqar_wsgi').with(
        'servername'                  => 'some.host.tld',
        'ip'                          => nil,
        'port'                        => '8888',
        'docroot'                     => "#{platform_params[:wsgi_script_path]}",
        'docroot_owner'               => 'zaqar',
        'docroot_group'               => 'zaqar',
        'ssl'                         => 'true',
        'wsgi_daemon_process'         => 'zaqar-server',
        'wsgi_daemon_process_options' => {
          'user'         => 'zaqar',
          'group'        => 'zaqar',
          'processes'    => 1,
          'threads'      => '42',
          'display-name' => 'zaqar_wsgi',
        },
        'wsgi_process_group'          => 'zaqar-server',
        'wsgi_script_aliases'         => { '/' => "#{platform_params[:wsgi_script_path]}/zaqar-server" },
        'require'                     => 'File[zaqar_wsgi]',
        'custom_fragment'             => 'WSGICallableObject app'
      )}
      it { is_expected.to contain_concat("#{platform_params[:httpd_ports_file]}") }
    end

    describe 'when overriding parameters using different ports' do
      let :params do
        {
          :servername                => 'dummy.host',
          :bind_host                 => '10.42.51.1',
          :port                      => 12345,
          :ssl                       => false,
          :wsgi_process_display_name => 'zaqar-server',
          :workers                   => 37,
        }
      end

      it { is_expected.to contain_apache__vhost('zaqar_wsgi').with(
        'servername'                  => 'dummy.host',
        'ip'                          => '10.42.51.1',
        'port'                        => '12345',
        'docroot'                     => "#{platform_params[:wsgi_script_path]}",
        'docroot_owner'               => 'zaqar',
        'docroot_group'               => 'zaqar',
        'ssl'                         => 'false',
        'wsgi_daemon_process'         => 'zaqar-server',
        'wsgi_daemon_process_options' => {
            'user'         => 'zaqar',
            'group'        => 'zaqar',
            'processes'    => '37',
            'threads'      => '42',
            'display-name' => 'zaqar-server',
        },
        'wsgi_process_group'          => 'zaqar-server',
        'wsgi_script_aliases'         => { '/' => "#{platform_params[:wsgi_script_path]}/zaqar-server" },
        'require'                     => 'File[zaqar_wsgi]',
        'custom_fragment'             => 'WSGICallableObject app'
      )}

      it { is_expected.to contain_concat("#{platform_params[:httpd_ports_file]}") }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 42,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :httpd_service_name => 'apache2',
            :httpd_ports_file   => '/etc/apache2/ports.conf',
            :wsgi_script_path   => '/usr/lib/cgi-bin/zaqar',
            :wsgi_script_source => '/usr/lib/python2.7/dist-packages/zaqar/transport/wsgi/app.py'
          }
        when 'RedHat'
          {
            :httpd_service_name => 'httpd',
            :httpd_ports_file   => '/etc/httpd/conf/ports.conf',
            :wsgi_script_path   => '/var/www/cgi-bin/zaqar',
            :wsgi_script_source => '/usr/lib/python2.7/site-packages/zaqar/transport/wsgi/app.py'
          }
        end
      end

      it_behaves_like 'apache serving zaqar with mod_wsgi'
    end
  end
end
