# Configure nova service
class plugin_unity::compute {

  include plugin_unity::common
  include ::nova::params

  service { 'nova-compute':
    ensure     => 'running',
    name       => $::name::params::compute_service_name,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  nova_config { 'libvirt/iscsi_use_multipath': value => 'True' }
  # TODO(peter) Need to figure out why use below statement
  Nova_config<||> ~> Service['nova-compute']
}
