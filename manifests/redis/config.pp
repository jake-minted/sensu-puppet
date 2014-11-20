# = Class: sensu::redis::config
#
# Sets the Sensu redis config
#
class sensu::redis::config {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $sensu::purge_config and !$sensu::server and !$sensu::api {
    $ensure = 'absent'
  } else {
    $ensure = 'present'
  }

  $file_ensure = $ensure ? {
    'absent'  => 'absent',
    default   => 'file'
  }

  file { '/etc/sensu/conf.d/redis.json':
    ensure  => $file_ensure,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0444',
    notify  => [ Service['sensu-server'], Service['sensu-api'] ]
  }

  sensu_redis_config { $::fqdn:
    ensure  => $ensure,
    host    => $sensu::redis_host,
    port    => $sensu::redis_port,
  }

}
