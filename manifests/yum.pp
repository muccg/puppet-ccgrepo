#
class ccgrepo::yum(
  $owner,
  $base,
  $s3dest,
  $group=$owner,
  ) {

  # fixme: createrepo in common::source
  $packages = ['createrepo', 'procmail']

  package {$packages: ensure => present }

  file { $base:
    ensure  => directory,
    mode    => '0755',
    owner   => $owner,
    group   => $group
  }

  file {"${base}/initrepo.sh":
    content => template('ccgrepo/yum/initrepo.sh.erb'),
    mode    => '0755',
    owner   => $owner,
    group   => $group,
    require => File[$base]
  }

  file {"${base}/repos.txt":
    content => template('ccgrepo/yum/repos.txt.erb'),
    mode    => '0755',
    owner   => $owner,
    group   => $group,
    require => File[$base]
  }

  exec { 'create repos':
    command => "${base}/initrepo.sh",
    user    => $owner,
    group   => $group,
    require => [ File["${base}/initrepo.sh"], File["${base}/repos.txt"] ],
    timeout => 1800,
    creates => "${base}/.created"
  }

  file {"${base}/updaterepo.sh":
    content => template('ccgrepo/yum/updaterepo.sh.erb'),
    mode    => '0755',
    owner   => $owner,
    group   => $group,
    require => File[$base]
  }

  file {"${base}/s3upload.sh":
    content => template('ccgrepo/yum/s3upload.sh.erb'),
    mode    => '0755',
    owner   => $owner,
    group   => $group,
    require => File[$base]
  }
}
