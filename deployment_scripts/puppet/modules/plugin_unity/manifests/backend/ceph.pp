#class plugin_unity::backend::ceph {
#  # We need handle if ceph is configured.
#  # Since ceph is configurated in a separate
#  # section, we only need to append its name to enabled_backends
#  $backends = $::fuel_settings['cinder']['enabled_backends']
#  cinder_config {
#    'DEFAULT/enabled_backends': value => "${backends},${backend_name}"
#  }
#}
