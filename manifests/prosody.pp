# @summary Manages prosody configuration.
#
class jitsimeet::prosody {

  class { 'prosody':
    user       => 'prosody',
    group      => 'prosody',
    admins     => [ "focus@auth.${jitsimeet::fqdn}", ],
    modules    => [ 'bosh', 'pubsub' ],
    components => {
      'conference'        => {
        'name' => "conference.${jitsimeet::fqdn}",
        'type' =>'muc',
      },
      'jitsi-videobridge' => {
        'name'   => "jitsi-videobridge.${jitsimeet::fqdn}",
        'secret' =>  $jitsimeet::jitsi_videobridge_secret,
      },
      'focus'             => {
        'name'   => "focus.${jitsimeet::fqdn}",
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
}
