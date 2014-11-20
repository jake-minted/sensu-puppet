# = Define: sensu::subscription
#
# Defines Sensu subscriptions
#
# == Parameters
#
# [*ensure*]
#   String. Whether the check should be present or not
#   Default: present
#   Valid values: present, absent

# [*custom*]
#   Hash.  Custom client variables
#   Default: {}
#
define sensu::subscription (
  $ensure       = 'present',
  $custom       = {},
) {

  validate_re($ensure, ['^present$', '^absent$'] )

  $file_ensure = $ensure ? {
    'absent'  => 'absent',
    default   => 'file'
  }

  file { "/etc/sensu/conf.d/subscription_${name}.json":
    ensure  => $file_ensure,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0444',
    before  => Sensu_client_subscription[$name],
    notify  => Service['sensu-server']
  }

  sensu_client_subscription { $name:
    ensure  => $ensure,
    custom  => $custom,
    notify  => Class['sensu::client::service'],
  }

}
