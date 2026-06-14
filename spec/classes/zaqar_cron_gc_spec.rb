require 'spec_helper'

describe 'zaqar::cron::gc' do

  shared_examples_for 'zaqar::cron::gc' do

    let :params do
      { :minute      => 1,
        :hour        => 0,
        :monthday    => '*',
        :month       => '*',
        :weekday     => '*',
        :user        => 'zaqar',
        :maxdelay    => 0,
      }
    end

    context 'ensure the cron job is absent' do
      before :each do
        params.merge!(
          :ensure => :absent,
        )
      end

      it 'removes the cron job' do
        is_expected.to contain_cron('zaqar-gc').with_ensure(:absent)
      end
    end

    context 'with defaults' do
      it 'configures a cron job' do
        is_expected.to contain_cron('zaqar-gc').with(
          :ensure      => :present,
          :command     => 'zaqar-gc',
          :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
          :user        => params[:user],
          :minute      => params[:minute],
          :hour        => params[:hour],
          :monthday    => params[:monthday],
          :month       => params[:month],
          :weekday     => params[:weekday],
          :require     => 'Anchor[zaqar::dbsync::end]',
        )
      end
    end

    context 'cron with maxdelay' do
      before :each do
        params.merge!(
          :maxdelay => 600
        )
      end

      it 'configures a cron with maxdelay' do
        is_expected.to contain_cron('zaqar-gc').with(
          :ensure      => :present,
          :command     => "sleep `expr ${RANDOM} \\% #{params[:maxdelay]}`; zaqar-gc",
          :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
          :user        => params[:user],
          :minute      => params[:minute],
          :hour        => params[:hour],
          :monthday    => params[:monthday],
          :month       => params[:month],
          :weekday     => params[:weekday],
          :require     => 'Anchor[zaqar::dbsync::end]',
        )
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
      it_configures 'zaqar::cron::gc'
    end
  end

end
