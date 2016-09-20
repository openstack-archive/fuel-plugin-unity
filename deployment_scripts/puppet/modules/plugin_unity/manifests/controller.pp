# Configuration change on controller node
class plugin_unity::controller {

  include plugin_unity::common
  include ::cinder::params

  $plugin_settings = hiera('unity')

  # Install cinder-volume if not present
  if $::cinder::params::volume_package {
    package { $::cinder:params::volume_package:
      ensure => present,
    }
    Package[$::cinder::params::volume_package] -> Cinder_config<||>
  }

  # TODO, configure backend, refer to "netapp.pp"
}
