# @summary Manages configuration file for the difference services.
#
class jitsimeet::config {

  file {
    "/etc/jitsi/meet/${jitsimeet::fqdn}-config.js":
      ensure  => present,
      content => epp('jitsimeet/meet-config.epp', {
        'fqdn'           => $jitsimeet::fqdn,
        'custom_options' => $jitsimeet::meet_custom_options,
      }),
      owner   => 'root',
      group   => 'jitsi',
      mode    => '0644';

    '/etc/jitsi/jicofo/config':
      ensure  => present,
      content => epp('jitsimeet/jicofo-config.epp', {
        'fqdn'                => $jitsimeet::fqdn,
        'focus_secret'        => $jitsimeet::focus_secret,
        'focus_user_password' => $jitsimeet::focus_user_password,
      }),
      owner   => 'jicofo',
      group   => 'jitsi',
      mode    => '0640',
      notify  => Service['jicofo'];

    '/etc/jitsi/videobridge/config':
      ensure  => present,
      content => epp('jitsimeet/jvb-config.epp', {
        'fqdn'       => $jitsimeet::fqdn,
        'jvb_secret' => $jitsimeet::jvb_secret,
      }),
      owner   => 'jvb',
      group   => 'jitsi',
      mode    => '0640',
      notify  => Service['jitsi-videobridge'];
  }
}
