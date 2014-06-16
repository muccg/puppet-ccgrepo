# installs the debian reprepro tool from source
class ccgrepo::reprepro(
  $owner='root',
  $group='root',
  $prefix='/usr/local',
  $version='4.13.1',
  ) {

  $download_url = "http://alioth.debian.org/frs/download.php/file/3909/reprepro_${version}.orig.tar.gz"

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
