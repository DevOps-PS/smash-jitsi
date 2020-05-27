# @summary Manages configuration file for the difference services.
#
class jitsimeet::config {

  file {
    "/etc/jitsi/meet/${jitsimeet::fqdn}-config.js":
      ensure  => present,
      content => epp('jitsimeet/meet-config.epp', {
        'fqdn'           => $jitsimeet::fqdn,
        'custom_options' => $jitsimeet::meet_custom_options,
        'domain_name'    => $jitsimeet::domain_name,
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
        'domain_name'         => $jitsimeet::domain_name,
      }),
      owner   => 'jicofo',
      group   => 'jitsi',
      mode    => '0640',
      notify  => Service['jicofo'];

    '/etc/jitsi/videobridge/config':
      ensure  => present,
      content => epp('jitsimeet/jvb-config.epp', {
        'fqdn'        => $jitsimeet::fqdn,
        'jvb_secret'  => $jitsimeet::jvb_secret,
        'domain_name' => $jitsimeet::domain_name,
      }),
      owner   => 'jvb',
      group   => 'jitsi',
      mode    => '0640',
      notify  => Service['jitsi-videobridge2'];

    '/usr/share/jitsi-videobridge/lib/videobridge.rc':
      ensure  => present,
      content => epp('jitsimeet/videobridge.rc.epp', {
        'jvb_max_memory' => $jitsimeet::jvb_max_memory,
      }),
      owner   => 'jvb',
      group   => 'jitsi',
      mode    => '0640',
      notify  => Service['jitsi-videobridge2'];
  }

  if $jitsimeet::manage_certs {
    # Files are pushed by the prosody module
    $certificates = [ $jitsimeet::fqdn, "auth.${jitsimeet::fqdn}" ]
    $certificates.each |Stdlib::FQDN $cert| {
      letsencrypt::certonly { $cert: }
    }
  }
}
