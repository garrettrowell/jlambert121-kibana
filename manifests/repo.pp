# == Class: kibana::repo
#
# This class installs kibana repositories to aid in installing the package.
# It should not be directly called.
#
class kibana::repo {

  case $::osfamily {
    'Debian': {
      include ::apt
        Class['apt::update'] -> Package[$kibana::package_name]

        apt::source { 'kibana':
          location    => "http://packages.elastic.co/kibana/${kibana::repo_version}/debian",
          release     => 'stable',
          repos       => 'main',
          key         => $::kibana::repo_key_id,
          key_source  => $::kibana::repo_key_source,
          include_src => false,
        }
    }
    'RedHat', 'Linux': {
      yumrepo { 'kibana':
        descr    => 'kibana repo',
        baseurl  => "http://packages.elastic.co/kibana/${kibana::repo_version}/centos",
        gpgcheck => 1,
        gpgkey   => $::kibana::repo_key_source,
        enabled  => 1,
      }
    }
    default: {
      fail("\"${module_name}\" provides no repository information
        for OSfamily \"${::osfamily}\"")
    }
  }

  # Package pinning
  case $::osfamily {
    'Debian': {
      include ::apt

      if ($kibana::package_pin == true and $kibana::version != false) {
        apt::pin { $kibana::package_name:
          ensure   => 'present',
          packages => $kibana::package_name,
          version  => $kibana::version,
          priority => 1000,
        }
      }
    }
    'RedHat', 'Linux': {
      if ($kibana::package_pin == true and $kibana::version != false) {
        yum::versionlock { "0:kibana-${kibana::pkg_version}.noarch":
          ensure => 'present',
        }
      }
    }
    default: {
      warning("Unable to pin package for OSfamily \"${::osfamily}\".")
    }
  }

}
