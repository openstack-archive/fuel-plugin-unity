# Install/configure common software/settings before running
# Unity Cinder driver

class plugin_unity::common {

  include plugin_unity::params
  # Make sure iscsi tools is installed and running
  package { $plugin_unity::params::iscsi_package_name:
    ensure => 'installed'
  }

  service { $plugin_emc_vnx::params::iscsi_service_name:
    ensure     => 'running',
    enable     => true,
    hasrestart => false,
    require    => $plugin_unity::params::iscsi_package_name,
  }

  # Make sure multipath tools is installed and running
  package {$pluin_unity::params::multipath_package_name:
    ensure => 'installed'
  }

  service {$plugin_emc_vnx::params::multipath_service_name:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    status     => 'pgrep multipathd',
    require    => Package[$plugin_emc_vnx::params::multipath_package_name],
  }

  # Provide multipath configuration file for EMC storage
  # TODO(peter) append if no EMC content?
  file {'multipath.conf':
    path    => '/etc/multipath.conf',
    mode    => '0644',
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/plugin_emc_vnx/multipath.conf',
    require => Package[$plugin_emc_vnx::params::multipath_package_name],
    notify  => Service[$plugin_emc_vnx::params::multipath_service_name],
  }
}
