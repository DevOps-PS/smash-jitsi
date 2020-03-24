# @summary Main class, includes all other classes.
#
# @param fqdn
#   The jitsi meet's fully qualified domain name.
#
# @param repo_key
#   Path to the _dearmored_ jitsi meet Debian repository GPG key.
#   Fingerprint should match 66A9 CD05 95D6 AFA 2472  90D3 BEF8 B479 E2DC 1389C
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
# @param focus_user_password
#   Password for the focus user.
#
class jitsimeet (
  Stdlib::Fqdn  $fqdn,
  String        $repo_key,
  String        $jitsi_vhost_ssl_key,
  String        $jitsi_vhost_ssl_cert,
  String        $auth_vhost_ssl_key,
  String        $auth_vhost_ssl_cert,
  String        $jitsi_videobridge_secret,
  String        $focus_secret,
  String        $focus_user_password,
) {

  include ::jitsimeet::install
  include ::jitsimeet::prosody
  include ::jitsimeet::services
}
