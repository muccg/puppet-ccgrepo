#
define ccgrepo::gpg_key_import($key_template, $keyid=undef, $owner=undef) {

  $tempfile = regsubst("/tmp/gpg_key_import_${title}", ' ', '_', 'G')

  if $keyid {
    $unless = "/usr/bin/gpg --list-keys ${keyid}"
  }

  file { $tempfile:
    content => template($key_template),
    owner   => $owner,
    mode    => '0600'
  }

  exec { "GNUPG Key Import ${title}":
    command     => "/usr/bin/gpg --import ${tempfile}",
    unless      => $unless,
    logoutput   => true,
    user        => $owner,
    environment => [ "HOME=/home/${owner}" ],
    returns     => [0, 2],
    require     => File[$tempfile]
  } ->

  exec { "Cleanup ${title}":
    command => "/bin/rm -f ${tempfile}"
  }
}
