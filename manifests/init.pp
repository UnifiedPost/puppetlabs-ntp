# == Class: ntp
#
# This module manages the ntp service.
#
# Tested platforms:
#  - Debian 6.0 Squeeze
#  - CentOS 5.4
#  - Amazon Linux 2011.09
#  - FreeBSD 9.0
#  - Archlinux
#
# === Parameters:
#
# [*ensure*]
#   Controll the service. Defaults to running.
#
# [*servers*]
#   Array of ntp servers to use.
#   Defaults to OS specific.
#
# [*restrict*]
#   Whether to restrict ntp daemons from allowing others to use as a server.
#   Defaults to true.
#
# [*autoupdate*]
#   Whether to update the ntp package automatically or not.
#   Defaults to false.
#
# [*enable*]
#   Automatically start ntp deamon on boot.
#   Defaults to true.
#
# [*config_template*]
#   Override with your own explicit template.
#   Defaults to OS specific.
#
# === Actions:
#
#  Installs, configures, and manages the ntp service.
#
# === Sample Usage:
#
#   class { "ntp":
#     servers    => [ 'time.apple.com' ],
#     autoupdate => false,
#   }
#
class ntp(
  $servers         = 'UNSET',
  $ensure          = 'running',
  $enable          = true,
  $restrict        = true,
  $config_template = undef,
  $autoupdate      = false
) {

  require ntp::params
  $pkg_name = $::ntp::params::pkg_name
  $svc_name = $::ntp::params::svc_name
  $config   = $::ntp::params::config
  $config_tpl = $::ntp::params::config_tpl
  $default_servers = $::ntp::params::default_servers


  if ! ($ensure in [ 'running', 'stopped' ]) {
    fail('ensure parameter must be running or stopped')
  }

  if $autoupdate == true {
    $package_ensure = 'latest'
  } elsif $autoupdate == false {
    $package_ensure = 'present'
  } else {
    fail('autoupdate parameter must be true or false')
  }

  $template_real = $config_template ? {
    undef   => "${module_name}/${config_tpl}",
    default => $config_template,
  }

  $servers_real = $servers ? {
    'UNSET' => $default_servers,
    default => $servers,
  }

  package { 'ntp':
    ensure => $package_ensure,
    name   => $pkg_name,
  }

  file { $config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template($template_real),
    require => Package[$pkg_name],
  }

  service { 'ntp':
    ensure     => $ensure,
    enable     => $enable,
    name       => $svc_name,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => [ Package[$pkg_name], File[$config] ],
  }
}
