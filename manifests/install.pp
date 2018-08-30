# == Class: wordpress::install
class wordpress::install inherits wordpress {
#Execute
exec { "apt-get update":
  path => "/usr/bin",
}

#Package install
package { "apache2":
  ensure => present,
}

#Package install
package { "mysql-server":
  ensure => present,
}

#Package install
package { "mysql-client":
  ensure => present,
  require => Package['mysql-server']
}

#LAMP Package install
$lamps = [ "php",  "libapache2-mod-php", "php-mcrypt", "php-mysql" ]
package { $lamps:
  ensure => present,
  require => Package['mysql-client']
}

}
