# == Class: wordpress::service
class wordpress::service inherits wordpress {

#Service
service { "apache2":
  ensure => running,
  require => Package['apache2'],
}

service { "mysql":
  ensure => running,
  require => Package['mysql-server'],
}

exec { "service apache2 restart":
  path => '/sbin:/bin:/usr/sbin:/usr/bin',
  require => File['/var/www/html/wp-config.php']
}

}
