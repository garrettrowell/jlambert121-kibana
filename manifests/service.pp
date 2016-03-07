# == Class: kibana::service
#
# This class manages the kibana service
#
#
class kibana::service {

  if ( versioncmp($::kibana::version, '4.4.1') >= 0 ) {
    service { 'kibana':
      ensure => running,
      enable => true,
    }
  } else {
    service { 'kibana':
      ensure   => running,
      enable   => true,
      require  => File['kibana-init-script'],
      provider => $::kibana::params::service_provider,
    }
  }
}
