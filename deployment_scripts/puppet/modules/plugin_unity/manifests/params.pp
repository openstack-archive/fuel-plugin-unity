# Default parameters used for Unity driver deployment
class plugin_unity::params {

  # TODO(peter) using hiera('unity')?
  $plugin_unity_settings = $::fuel_setttings['unity']

  $volume_driver         = $plugin_unity_settings['volume_driver']
  $storage_protocol      = $plugin_unity_settings['storage_protocol']
  $storage_pool_names    = $plugin_unity_settings['storage_pool_names']
  $volume_backend_name   = $plugin_unity_settings['volume_backend_name']
  $san_ip   = $plugin_unity_settings['san_ip']
  $san_login   = $plugin_unity_settings['san_login']
  $san_password   = $plugin_unity_settings['san_password']
  $volume_driver   = $plugin_unity_settings['volume_driver']
  $multipath_cinder   = $plugin_unity_settings['use_multipath_for_image_xfer']
  $multipath_nova   = $plugin_unity_settings['iscsi_use_multipath']
  $over_subscription   = $plugin_unity_settings['max_over_subscription_ratio']
  # TODO need to figure out what if it's different that lvm/ceph's
  $ha_host_name = 'ha:unity'
  $cinder_hash = $::fuel_settings['cinder']
  $storage_hash = $::fuel_settings['storage']

  case $::osfamily {
    'Debian': {
      $iscsi_package_name = 'open-iscsi'
      $iscsi_service_name = 'open-iscsi'
      $multipath_package_name = 'multipath-tools'
      $multipath_service_name = 'multipath-tools'
      $naviseccli_package_name = 'navicli-linux-64-x86-en-us'
    }
    'RedHat': {
      $iscsi_package_name = 'iscsi-initiator-utils'
      $iscsi_service_name = false
      $multipath_package_name = 'device-mapper-multipath'
      $multipath_service_name = 'multipathd'
      $naviseccli_package_name = 'NaviCLI-Linux-64-x86-en_US'
    }
    default: {
      fail("unsuported osfamily ${::osfamily}, \
      currently Debian and Redhat family are the only supported platforms")
    }

    # Add support for coexistence for lvm/ceph
    if ($storage_hash['volumes_lvm']) or ($storage_hash['volumes_ceph']) {
      $backends = ''
    } else {
      $backends = $cinder_hash['DEFAULT']['enabled_backends']
    }
  }

}
