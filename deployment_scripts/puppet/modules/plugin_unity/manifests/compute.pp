# Configure nova service
class plugin_unity::compute {

  include plugin_unity::common
  include ::nova::params
  include plugin_unity::params

  service { 'nova-compute':
    ensure     => 'running',
    name       => $::nova::params::compute_service_name,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  nova_config {
    'libvirt/iscsi_use_multipath': value   =>
    $plugin_unity::params::multipath_nova;
    'notify': value                        =>
    Service[$::nova::params::compute_service_name];
  }
  # TODO(peter) Need to figure out why use below statement
  Nova_config<||> ~> Service['nova-compute']
}
