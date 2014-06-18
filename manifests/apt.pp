#
class ccgrepo::apt (
  $repodir=$title,
  $owner,
  $s3dest,
  $pubkey_template,
  $reprepro_download_url,
  $reprepro_version,
  ) {

  $repo_dirs = [ $repodir, "${repodir}/tmp", "${repodir}/conf", "${repodir}/incoming" ]

  file { $repo_dirs:
    ensure => directory,
    owner  => $owner,
    mode   => '0755',
  }

  file {"${repodir}/conf/distributions":
    content => template('ccgrepo/apt/distributions.erb'),
    owner   => $owner,
    require => File[$repo_dirs]
  }

  file {"${repodir}/conf/incoming":
    content => template('ccgrepo/apt/incoming.erb'),
    owner   => $owner,
    require => File[$repo_dirs]
  }

  file {"${repodir}/processincoming.sh":
    content => template('ccgrepo/apt/processincoming.sh.erb'),
    mode    => '0755',
    owner   => $owner,
    require => File[$repo_dirs]
  }

  file {"${repodir}/s3upload.sh":
    content => template('ccgrepo/apt/s3upload.sh.erb'),
    mode    => '0755',
    owner   => $owner,
    require => File[$repo_dirs]
  }

  file {"${repodir}/ccg-archive.asc":
    content => template($pubkey_template),
    owner   => $owner
  }

  class { 'ccgrepo::reprepro':
    download_url => $reprepro_download_url,
    owner        => $owner,
    version      => $reprepro_version,
  }
}
