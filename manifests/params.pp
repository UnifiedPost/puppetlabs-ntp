class ntp::params {

  case $::osfamily {
    Debian: {
      $supported       = true
      $pkg_name        = [ 'ntp' ]
      $svc_name        = 'ntp'
      $config          = '/etc/ntp.conf'
      $config_tpl      = 'ntp.conf.debian.erb'
      $default_servers = [
        '0.debian.pool.ntp.org iburst',
        '1.debian.pool.ntp.org iburst',
        '2.debian.pool.ntp.org iburst',
        '3.debian.pool.ntp.org iburst',
      ]
    }
    RedHat: {
      $supported       = true
      $pkg_name        = [ 'ntp' ]
      $svc_name        = 'ntpd'
      $config          = '/etc/ntp.conf'
      $config_tpl      = 'ntp.conf.el.erb'
      $default_servers = [
        '0.centos.pool.ntp.org',
        '1.centos.pool.ntp.org',
        '2.centos.pool.ntp.org',
      ]
    }
    SuSE: {
      $supported       = true
      $pkg_name        = [ 'ntp' ]
      $svc_name        = 'ntp'
      $config          = '/etc/ntp.conf'
      $config_tpl      = 'ntp.conf.suse.erb'
      $default_servers = [
        '0.opensuse.pool.ntp.org',
        '1.opensuse.pool.ntp.org',
        '2.opensuse.pool.ntp.org',
        '3.opensuse.pool.ntp.org',
      ]
    }
    FreeBSD: {
      $supported       = true
      $pkg_name        = ['net/ntp']
      $svc_name        = 'ntpd'
      $config          = '/etc/ntp.conf'
      $config_tpl      = 'ntp.conf.freebsd.erb'
      $default_servers = [
        '0.freebsd.pool.ntp.org iburst maxpoll 9',
        '1.freebsd.pool.ntp.org iburst maxpoll 9',
        '2.freebsd.pool.ntp.org iburst maxpoll 9',
        '3.freebsd.pool.ntp.org iburst maxpoll 9',
      ]
    }

    Linux: {
      if ($::operatingsystem == 'Archlinux') {
        $supported       = true
        $pkg_name        = ['ntp']
        $svc_name        = 'ntpd'
        $config          = '/etc/ntp.conf'
        $config_tpl      = 'ntp.conf.archlinux.erb'
        $default_servers = [
          '0.pool.ntp.org',
          '1.pool.ntp.org',
          '2.pool.ntp.org' ,
        ]
      } else {
        fail("The ${module_name} module is not supported on an ${::operatingsystem} system")
      }
    }

    default: {
      fail("The ${module_name} module is not supported on ${::osfamily} based systems")
    }
  }

}
