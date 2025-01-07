# == Class: zaqar::signed_url
#
# Configure signed_url options
#
# === Parameters
#
# [*secret_key*]
#  (Required) Secret key used to encrypt pre-signed URLs.
#
class zaqar::signed_url(
  $secret_key,
) {

  include zaqar::deps

  zaqar_config {
    'signed_url/secret_key': value => $secret_key, secret => true;
  }

}
