class jitsimeet::install {

# Debs taken from https://download.jitsi.org/jitsi-videobridge/debian/. I've
# manually verified the signatures with the main Jitsi dev key:
# https://download.jitsi.org/jitsi-key.gpg.key
#
# Yes, this sucks.

  $debs = [ 'jicofo_1.0-534-1_all.deb',
            'jitsi-meet-prosody_1.0.3902-1_all.deb',
            'jitsi-meet-web-config_1.0.3902-1_all.deb',
            'jitsi-meet_1.0.4301-1_all.deb',
            'jitsi-meet-web_1.0.3902-1_all.deb',
            'jitsi-videobridge_1132-1_amd64.deb' ]

  $debs.each |String $deb| {
    $package = regsubst($deb, '_.+\.deb$', '')

    file {"/var/cache/apt/archives/${deb}":
      ensure => present,
      source => "${packages_path}/${deb}",
      owner  => 'root',
      group  => 'root',
      mode   => '0644';
    }

    package {${package}:
      ensure   => present,
      provider => 'dpkg',
      source   => "/var/cache/apt/archives/${deb}",
      require  => File["/var/cache/apt/archives/${deb}"];
    }
  }

# Taken from the dependency info in the jitsi packages

  package {
    [ 'openjdk-11-jre-headless',
      'prosody',
      'uuid-runtime' ]:
      ensure => present;
  }
}
