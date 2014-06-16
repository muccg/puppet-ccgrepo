#
class ccgrepo (
    $aws_access_key,
    $aws_secret_key,
    $owner,
    $gpg_passphrase=''
  ) {

  $packages = ['s3cmd']

  package { $packages:
    ensure => installed
  }

  class {'s3cmd':
    aws_access_key => $aws_access_key,
    aws_secret_key => $aws_secret_key,
    gpg_passphrase => $gpg_passphrase,
    owner          => $owner,
    require        => Package[$packages]
  }
}
