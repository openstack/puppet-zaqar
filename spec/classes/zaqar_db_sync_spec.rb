require 'spec_helper'

describe 'zaqar::db::sync' do

  shared_examples_for 'zaqar-dbsync' do

    it { is_expected.to contain_class('zaqar::deps') }

    it 'runs zaqar-db-sync' do
      is_expected.to contain_exec('zaqar-db-sync').with(
        :command     => 'zaqar-manage db_sync',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :user        => 'zaqar',
        :try_sleep   => 5,
        :tries       => 10,
        :subscribe   => ['Anchor[zaqar::install::end]',
                         'Anchor[zaqar::config::end]',
                         'Anchor[zaqar::dbsync::begin]'],
        :notify      => 'Anchor[zaqar::dbsync::end]',
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'zaqar-dbsync'
    end
  end

end
