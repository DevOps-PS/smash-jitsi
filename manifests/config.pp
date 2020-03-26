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

  if $jitsimeet::manage_fqdn_cert {
    $fqdn_cert = [ $jitsimeet::fqdn ]
  } else {
    $fqdn_cert = []
  }

  if $jitsimeet::manage_misc_certs {
    $misc_cert = [ "auth.${jitsimeet::fqdn}",
                  "conference.${jitsimeet::fqdn}",
                  "focus.${jitsimeet::fqdn}",
                  "jvb.${jitsimeet::fqdn}" ]
  } else {
    $misc_cert = []
  }

  if $jitsimeet::manage_misc_certs or $jitsimeet::manage_fqdn_cert {
    $certificates = $fqdn_cert + $misc_cert
    $certificates.each |Stdlib::FQDN $cert| {
      letsencrypt::certonly { $cert: }
      file {
        default:
          ensure  => file,
          owner   => 'prosody',
          group   => 'prosody',
          mode    => '0400',
          notify  => Service['prosody'],
          require => Letsencrypt::Certonly[$cert];
        "/etc/prosody/certs/${cert}.key":
          source => "/etc/letsencrypt/live/${cert}/privkey.pem";
        "/etc/prosody/certs/${cert}.crt":
          source => "/etc/letsencrypt/live/${cert}/cert.pem";
      }
    }
  }
}
