# Default parameters used for Unity driver deployment
class plugin_unity::params {

  $volume_driver         = 'cinder.volume.drivers.emc.emc_unity.EMCUnityDriver'
  $storage_protocol       = 'iSCSI'
  # TODO(peter) wording `emc` is proper?
  $volume_backend_name   = 'emc_unity'
  $cinder_hash = $::fuel_settings['cinder']
  $storage_hash = $::fuel_settings['storage']

  case $::osfamily {
    'Debian': {
      $iscsi_package_name = 'open-iscsi'
      $iscsi_service_name = 'open-iscsi'
      $multipath_package_name = 'multipath-tools'
      $multipath_service_name = 'multipath-tools'
    }
    'RedHat': {
      $iscsi_package_name = 'iscsi-initiator-utils'
      $iscsi_service_name = false
      $multipath_package_name = 'device-mapper-multipath'
      $multipath_service_name = 'multipathd'
    }
    default: {
      fail("unsuported osfamily ${::osfamily}, \
      currently Debian and Redhat family are the only supported platforms")
    }

    # Add support for coexistence for lvm/ceph

    if ($storage_hash['volumes_lvm']) {
      $backends = 'cinder_lvm'
      $backend_class = 'plugin_unity::backend::lvm'
    } elsif ($storage_hash['volume_ceph']) {
      $backends = 'cinder_ceph'
      $backend_class = 'plugin_cinder_netapp::backend::ceph'
    }
  }

}
