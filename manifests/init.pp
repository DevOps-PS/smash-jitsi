# @summary Main class, includes all other classes.
#
# @param fqdn
#   The jitsi meet's fully qualified domain name.
#
# @param packages_path
#   Path to the directory holding the jitsi meet packages on the puppet master.
#
# @param jitsi_videobridge_secret
#   The jitsi-videobridge component's secret.
#
# @param focus_secret
#   The focus component's secret.
#
class jitsimeet (
  Stdlib::Fqdn $fqdn               = undef,
  String $packages_path            = "puppet:///files/jitsimeet/packages",
  String $jitsi_videobridge_secret = undef,
  String $focus_secret             = undef,
) {

  include ::jitsimeet::install
  include ::jitsimeet::prosody
}
