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
          'storage'         => '"memory"',
          'modules_enabled' => '{ "token_verification" }',
        },
      },
      "jitsi-videobridge.${jitsimeet::fqdn}" => {
        'secret' =>  $jitsimeet::jvb_secret,
      },
      "focus.${jitsimeet::fqdn}"             => {
        'secret' =>  $jitsimeet::focus_secret,
      },
      "internal.auth.${jitsimeet::fqdn}"     => {
        'type'    =>'muc',
        'options' => {
          'storage'         => '"memory"',
        },
      },
    }
  }

  prosody::virtualhost {
    $jitsimeet::fqdn:
      ensure         => present,
      ssl_key        => $jitsimeet::jitsi_vhost_ssl_key,
      ssl_cert       => $jitsimeet::jitsi_vhost_ssl_cert,
      custom_options => {
        'authentication'         => 'token',
        'c2s_require_encryption' => false,
        'modules_enabled'        => [ 'bosh', 'pubsub', 'ping' ],
        'app_id'                 => $jitsimeet::jwt_app_id,
        'app_secret'             => $jitsimeet::jwt_app_secret,
        'allow_empty_token'      => false,
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
      command     => '/usr/sbin/update-ca-certificates -f',
      refreshonly => true;
  }

  file {
    default:
      ensure => link,
      force  => true,
      notify => Exec['update-ca-certificates'];
    "/usr/local/share/ca-certificates/auth.${jitsimeet::fqdn}.key":
      target => "/etc/prosody/certs/auth.${jitsimeet::fqdn}.key";
    "/usr/local/share/ca-certificates/auth.${jitsimeet::fqdn}.crt":
      target => "/etc/prosody/certs/auth.${jitsimeet::fqdn}.crt";
  }
}
