# = Class: zaqar::server
#
# This class manages cron job to run periodic gc task.
#
# === Parameters
#
#  [*minute*]
#    (optional) Defaults to '1'.
#
#  [*hour*]
#    (optional) Defaults to '0'.
#
#  [*monthday*]
#    (optional) Defaults to '*'.
#
#  [*month*]
#    (optional) Defaults to '*'.
#
#  [*weekday*]
#    (optional) Defaults to '*'.
#
#  [*user*]
#    (optional) User with access to zaqar files.
#    Defaults to $zaqar::params::user.
#
#  [*maxdelay*]
#    (optional) In Seconds. Should be a positive integer.
#    Induces a random delay before running the cronjob to avoid running
#    all cron jobs at the same time on all hosts this job is configured.
#    Defaults to 0.
#
#  [*ensure*]
#    (optional) Ensure cron jobs present or absent
#    Defaults to present.
#
class zaqar::cron::gc (
  $minute                           = 1,
  $hour                             = 0,
  $monthday                         = '*',
  $month                            = '*',
  $weekday                          = '*',
  $user                             = $zaqar::params::user,
  Integer[0] $maxdelay              = 0,
  Enum['present', 'absent'] $ensure = 'present',
) inherits zaqar::params {
  include zaqar::deps

  if $maxdelay == 0 {
    $delay_cmd = ''
  } else {
    $delay_cmd = "sleep `expr \${RANDOM} \\% ${maxdelay}`; "
  }

  cron { 'zaqar-gc':
    ensure      => $ensure,
    command     => "${delay_cmd}zaqar-gc",
    environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
    user        => $user,
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Anchor['zaqar::dbsync::end'],
  }
}
