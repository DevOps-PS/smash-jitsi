# @summary Manages package installation.
#
class jitsimeet::install {

  apt::source {
    'jitsimeet':
      comment  => 'Jitsi Meet',
      location => '[signed-by=/usr/share/keyrings/jitsimeet.gpg] https://download.jitsi.org',
      repos    => '',
      release  => 'stable/';
  }

  apt::pin {
    'jitsimeet':
      packages   => [ 'jicofo',
                      'jitsi-meet-prosody',
                      'jitsi-meet-web-config',
                      'jitsi-meet',
                      'jitsi-meet-web',
                      'jitsi-videobridge' ],
      priority   => 1000,
      originator => 'jitsi.org',
      label      => 'Jitsi Debian packages repository',
      codename   => 'stable';

    'jitsimeet-negative':
      packages   => '*',
      priority   => 200,
      originator => 'jitsi.org',
      label      => 'Jitsi Debian packages repository',
      codename   => 'stable';
  }

  file {
    '/usr/share/keyrings/jitsimeet.gpg':
      ensure => present,
      source => $jitsimeet::repo_key,
      owner  => 'root',
      group  => 'root',
      mode   => '0644';
  }

  package {
    'jitsi-meet':
      ensure => present;
  }
}
