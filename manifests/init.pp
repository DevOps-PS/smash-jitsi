# @summary Main class, includes all other classes.
#
# @param fqdn
#   The jitsi meet's fully qualified domain name.
#
# @param packages_path
#   Path to the directory holding the jitsi meet packages on the puppet master.
#
# @param jitsi_virtualhost_ssl_key
#   Path to the jitsi virtualhost ssl key.
#
# @param jitsi_virtualhost_ssl_cert
#   Path to the jitsi virtualhost ssl certificate.
#
# @param auth_virtualhost_ssl_key
#   Path to the authentication virtualhost ssl key.
#
# @param auth_virtualhost_ssl_cert
#   Path to the authentication virtualhost ssl certificate.
#
# @param jitsi_videobridge_secret
#   The jitsi-videobridge component's secret.
#
# @param focus_secret
#   The focus component's secret.
#
class jitsimeet (
  Stdlib::Fqdn $fqdn                 = undef,
  String $packages_path              = "puppet:///files/jitsimeet/packages",
  String $jitsi_virtualhost_ssl_key  = "puppet:///files/jitsimeet/prosody/jitsi-${fqdn}.key",
  String $jitsi_virtualhost_ssl_cert = "puppet:///files/jitsimeet/prosody/jitsi-${fqdn}.crt",
  String $auth_virtualhost_ssl_key   = "puppet:///files/jitsimeet/prosody/auth-${fqdn}.key",
  String $auth_virtualhost_ssl_cert  = "puppet:///files/jitsimeet/prosody/auth-${fqdn}.crt",
  String $jitsi_videobridge_secret   = undef,
  String $focus_secret               = undef,
) {

  include ::jitsimeet::install
  include ::jitsimeet::prosody
}
