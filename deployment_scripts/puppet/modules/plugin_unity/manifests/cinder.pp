# Configuration change for Cinder nodes
class plugin_unity::cinder {
  package { 'cinder-volume':
    ensure => present,
    }
  # Copy unity driver file to cinder node
  file { 'emc_unity.py':
        path   => '/usr/lib/python2.7/dist-packages/cinder/volume/drivers/emc/emc_unity.py',
        source => 'puppet:///modules/emc_unity.py',
        mode   => '644',
        owner  => 'root',
        group  => 'root',
  }
}
