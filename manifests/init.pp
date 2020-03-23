# @summary Main class, includes all other classes.
#
# @param fqdn
#   The jitsi meet's fully qualified domain name.
#
# @param packages_path
#   Path to the directory holding the jitsi meet packages on the puppet master.
#
# @param jitsi_vhost_ssl_key
#   Path to the jitsi virtualhost ssl key.
#
# @param jitsi_vhost_ssl_cert
#   Path to the jitsi virtualhost ssl certificate.
#
# @param auth_vhost_ssl_key
#   Path to the authentication virtualhost ssl key.
#
# @param auth_vhost_ssl_cert
#   Path to the authentication virtualhost ssl certificate.
#
# @param jitsi_videobridge_secret
#   The jitsi-videobridge component's secret.
#
# @param focus_secret
#   The focus component's secret.
#
class jitsimeet (
  Stdlib::Fqdn  $fqdn,
  String        $packages_path,
  String        $jitsi_vhost_ssl_key,
  String        $jitsi_vhost_ssl_cert,
  String        $auth_vhost_ssl_key,
  String        $auth_vhost_ssl_cert,
  String        $jitsi_videobridge_secret,
  String        $focus_secret,
) {

  include ::jitsimeet::install
  include ::jitsimeet::prosody
}
