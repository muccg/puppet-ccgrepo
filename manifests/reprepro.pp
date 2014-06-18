# installs the debian reprepro tool from source
class ccgrepo::reprepro(
  $download_url = "http://ubuntu.mirror.serversaustralia.com.au/ubuntu/pool/universe/r/reprepro/reprepro_4.13.1.orig.tar.gz"
  $owner='root',
  $group='root',
  $prefix='/usr/local',
  $version='4.13.1',
  ) {


  $packages = ['zlib-devel', 'bzip2-devel', 'libarchive-devel', 'db4-devel', 'gpgme-devel', 'gpgme' ]

  package {$packages: ensure => present }

  puppi::netinstall { 'reprepro':
    url                 => $download_url,
    extracted_dir       => "reprepro-${version}",
    destination_dir     => $prefix,
    owner               => $owner,
    group               => $group,
    work_dir            => '/usr/local/src',
    path                => "/usr/local/reprepro-${version}:/bin:/sbin:/usr/bin:/usr/sbin",
    postextract_command => "configure --prefix=${prefix} && make -j2 && make install"
  }

}
