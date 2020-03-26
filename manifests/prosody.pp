# @summary Manages prosody configuration.
#
class jitsimeet::prosody {

  class { 'prosody':
    user                   => 'prosody',
    group                  => 'prosody',
    admins                 => [ "focus@auth.${jitsimeet::fqdn}", ],
    ssl_custom_config      => false,
    c2s_require_encryption => false,
    s2s_require_encryption => false,
    s2s_secure_auth        => false,
    daemonize              => false,
    custom_options         => {
      'https_ports'  => '{}',
      'certificates' => '"certs"',
    },
    components             => {
      "conference.${jitsimeet::fqdn}"        => {
        'type'    =>'muc',
        'options' => {
          'storage' => '"memory"',
        },
      },
      "jitsi-videobridge.${jitsimeet::fqdn}" => {
        'secret' =>  $jitsimeet::jvb_secret,
      },
      "focus.${jitsimeet::fqdn}"             => {
        'secret' =>  $jitsimeet::focus_secret,
      },
    }
  }

  prosody::virtualhost {
    $jitsimeet::fqdn:
      ensure         => present,
      ssl_key        => $jitsimeet::jitsi_vhost_ssl_key,
      ssl_cert       => $jitsimeet::jitsi_vhost_ssl_cert,
      custom_options => {
        'authentication'         => 'anonymous',
        'c2s_require_encryption' => false,
        'modules_enabled'        => [ 'bosh', 'pubsub', 'ping' ],
      };
  }

  prosody::virtualhost {
    "auth.${jitsimeet::fqdn}":
      ensure         => present,
      ssl_key        => $jitsimeet::auth_vhost_ssl_key,
      ssl_cert       => $jitsimeet::auth_vhost_ssl_cert,
      custom_options => {
        'authentication' => 'internal_plain',
      };
  }

  prosody::user { 'focus':
    host => "auth.${jitsimeet::fqdn}",
    pass => $jitsimeet::focus_user_password;
  }

  exec {
    'update-ca-certificates':
      command     => 'update-ca-certificates -f',
      refreshonly => true;
  }

  $jitsimeet::certificates.each |Stdlib::FQDN $cert| {
    file {
      default:
        ensure => link,
        force  => true,
        notify => Exec['update-ca-certificates'],
      "/usr/local/share/ca-certificates/${cert}.key":
        target => "/etc/prosody/certs/${cert}.key";
      "/usr/local/share/ca-certificates/${cert}.crt":
        target => "/etc/prosody/certs/${cert}.crt";
    }
  }
}
