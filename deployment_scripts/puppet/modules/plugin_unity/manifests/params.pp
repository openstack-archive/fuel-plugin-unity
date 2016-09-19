# Default parameters used for Unity driver deployment
class plugin_unity::params {

  $volume_driver         = 'cinder.volume.drivers.emc.emc_unity.EMCUnityDriver'
  $storage_protocl       = 'iSCSI'
  # TODO(peter) wording `emc` is proper?
  $volume_backend_name   = 'emc_unity'

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
  }

}
