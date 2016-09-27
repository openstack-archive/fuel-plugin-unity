# Configure unity driver name by inserting
# specified values from UI
class plugin_unity::backend::unity (
  $backends = $plugin_unity::params::backends,
  $use_multipath = $plugin_unity::params::multipath_cinder,
  $san_ip = $plugin_unity::params::san_ip,
  $san_login = $plugin_unity::params::san_login,
  $san_password = $plugin_unity::params::san_password,
  $volume_backend_name = plugin_unity::params::volume_backend_name,
  $storage_pool_names = $plugin_unity::params::storage_pool_names,
  $storage_protocol = $plugin_unity::params::storage_protocol,
  $volume_driver = $plugin_unity::params::volume_driver,
  $over_subscription = $plugin_unity::params::over_subscription,
  $ha_host_name = $plugin_unity::params::ha_host_name,
) inherits plugin_unity::params {

  cinder_config {
    "${name}/san_ip": value => $san_ip,
    "${name}/san_login": value => $san_login,
    "${name}/san_password": value => $san_password,
    "${name}/storage_protocol": value => $storage_protocol,
    "${name}/storage_pool_names": value => $storage_pool_names,
    "${name}/volume_driver": value => $volume_driver,
    "${name}/volume_backend_name": value => $volume_backend_name,
    "${name}/use_multipath_for_image_xfer": value => $use_multipath,
    "${name}/max_over_subscription_ratio": value => $over_subscription,
    "${name}/backend_host": value => $ha_host_name,
  }
}
