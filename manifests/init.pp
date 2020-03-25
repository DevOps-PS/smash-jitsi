# @summary Main class, includes all other classes.
#
# @param fqdn
#   The jitsi meet's fully qualified domain name.
#
# @param repo_key
#   Path to the _dearmored_ jitsi meet Debian repository GPG key.
#   Fingerprint should match 66A9 CD05 95D6 AFA 2472  90D3 BEF8 B479 E2DC 1389C
#
# @param manage_fqdn_cert
#   If the TLS certificate for the FQDN of the jitsi instance should be managed
#   using Let's Encrypt.
#
# @param manage_misc_certs
#   If the TLS certificates for the other domains needed (auth.FQDN, focus.FQDN, etc.)
#   should be managed using Let's Encrypt.
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
# @param jvb_secret
#   The jitsi-videobridge component's secret.
#
# @param focus_secret
#   The focus component's secret.
#
# @param focus_user_password
#   Password for the focus user.
#
# @param meet_custom_options
#   Custom options to be passed to the main jitsi configuration file.
#
class jitsimeet (
  Stdlib::Fqdn  $fqdn,
  String        $repo_key,
  Boolean       $manage_fqdn_cert,
  Boolean       $manage_misc_certs,
  String        $jitsi_vhost_ssl_key,
  String        $jitsi_vhost_ssl_cert,
  String        $auth_vhost_ssl_key,
  String        $auth_vhost_ssl_cert,
  String        $jvb_secret,
  String        $focus_secret,
  String        $focus_user_password,
  Hash          $meet_custom_options,
) {

  include ::jitsimeet::config
  include ::jitsimeet::install
  include ::jitsimeet::prosody
  include ::jitsimeet::services
}
