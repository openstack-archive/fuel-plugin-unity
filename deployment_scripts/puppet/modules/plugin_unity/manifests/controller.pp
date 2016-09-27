# Configuration change on controller node
class plugin_unity::controller {

  include plugin_unity::common
  include ::cinder::params

  $plugin_settings = hiera('unity')
  $section_name = 'unity'
  # Install cinder-volume if not present
  if $::cinder::params::volume_package {
    package { "${::cinder:params::volume_package}":
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
    source => 'puppet:///modules/emc_unity.py',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  plugin_unity::backend::unity { $section_name: }

  $storage_hash = $::fuel_settings['storage']
  cinder_config {
    'DEFAULT/enabled_backends': value =>
    "${plugin_unity::params::backends},${section_name}",
  }
  # Restart cinder volume service
  #Cinder_config<||> ~> Service['cinder_volume']
  service { $cinder::params::volume_service: }
}
