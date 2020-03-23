class jitsimeet::prosody {

  class { 'prosody':
    user       => 'prosody',
    group      => 'prosody',
    admins     => [ "focus@auth.${jitsimeet::fqdn}", ],
    components => {
      'conference'        => {
        'name' => "conference.${jitsimeet::fqdn}",
        'type' =>'muc',
      },
      'jitsi-videobridge' => {
        'name'   => "jitsi-videobridge.${jitsimeet::fqdn}",
        'secret' =>  $jitsimeet::jitsi_videobridge_secret,
      },
      'focus' => {
        'name'   => "focus.${jitsimeet::fqdn}",
        'secret' =>  $jitsimeet::focus_secret,
      },
    }
  }

  prosody::virtualhost {
    "${jitsimeet::fqdn}":
      ensure                 => present,
      ssl_key                => "puppet:///files/jitsimeet/prosody/appel.sogeecom.org.key",
      ssl_cert               => "puppet:///files/jitsimeet/prosody/appel.sogeecom.org.crt",
      module_base            => [ 'bosh', 'pubsub' ],
      authentication         => 'anonymous',
      c2s_require_encryption => false,
  }

  prosody::virtualhost {
    "auth.${jitsimeet::fqdn}":
      ensure         => present,
      ssl_key        => "puppet:///files/jitsimeet/prosody/auth.appel.sogeecom.org.key",
      ssl_cert       => "puppet:///files/jitsimeet/prosody/auth.appel.sogeecom.org.crt",
      authentication => 'internal_plain',
  }
}
