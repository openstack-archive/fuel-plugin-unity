# Configuration change on controller node
class plugin_unity::controller {

  include plugin_unity::common
  include ::cinder::params
  include plugin_unity::params

  $plugin_settings = hiera('cinder-unity')
  $section_name = 'unity'
  # Install cinder-volume if not present
  if $::cinder::params::volume_package {
    package { $::cinder::params::volume_package:
      ensure => 'installed',
    }
    Package[$::cinder::params::volume_package] -> Cinder_config<||>
  }

  package { $plugin_unity::params::naviseccli_package_name:
    ensure => 'installed',
  }

  # Copy unity driver file to cinder node
  file { 'emc_unity.py':
    path   =>
    '/usr/lib/python2.7/dist-packages/cinder/volume/drivers/emc/emc_unity.py',
    source => 'puppet:///modules/plugin_unity/emc_unity.py',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  plugin_unity::backend::unity { $section_name:
    san_ip              => $plugin_unity::params::san_ip,
    san_login           => $plugin_unity::params::san_login,
    san_password        => $plugin_unity::params::san_password,
    use_multipath       => $plugin_unity::params::multipath_cinder,
    volume_backend_name => $plugin_unity::params::volume_backend_name,
    storage_pool_names  => $plugin_unity::params::storage_pool_names,
    storage_protocol    => $plugin_unity::params::storage_protocol,
    volume_driver       => $plugin_unity::params::volume_driver,
    over_subscription   => $plugin_unity::params::over_subscription,
    ha_host_name        => $plugin_unity::params::ha_host_name,
  }

  # Insert `enabled_backends`
  ini_subsetting {"enable_${section_name}_backend":
    ensure               => present,
    section              => 'DEFAULT',
    key_val_separator    => '=',
    path                 => '/etc/cinder/cinder.conf',
    setting              => 'enabled_backends',
    subsetting           => $section_name,
    subsetting_separator => ',',
    notify               => Service[$cinder::params::volume_service],
  }

  # Restart cinder volume service
  #Cinder_config<||> ~> Service['cinder_volume']
  # TODO Need to test on real HA environment
  service { $cinder::params::volume_service:
    ensure => 'running',
  }
}
