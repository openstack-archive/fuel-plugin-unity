# Configure unity driver name by inserting
# specified values from UI
define plugin_unity::backend::unity (
  $san_ip,
  $san_login,
  $san_password,
  $use_multipath       = 'True',
  $volume_backend_name = 'unity',
  $storage_pool_names  = undef,
  $storage_protocol    = 'iSCSI',
  $volume_driver       = 'cinder.volume.drivers.emc.emc_unity.EMCUnityDriver',
  $over_subscription   = '20.0',
  $ha_host_name        = 'ha:unity',
) {

  cinder_config {
    "${name}/san_ip": value                       => $san_ip;
    "${name}/san_login": value                    => $san_login;
    "${name}/san_password": value                 => $san_password;
    "${name}/storage_protocol": value             => $storage_protocol;
    "${name}/volume_driver": value                => $volume_driver;
    "${name}/volume_backend_name": value          => $volume_backend_name;
    "${name}/use_multipath_for_image_xfer": value => $use_multipath;
    "${name}/max_over_subscription_ratio": value  => $over_subscription;
    "${name}/backend_host": value                 => $ha_host_name;
  }
  if $storage_pool_names {
    cinder_config {
      "${name}/storage_pool_names": value => $storage_pool_names;
    }
  }
}
