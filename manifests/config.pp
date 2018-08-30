# == Class: wordpress::config
class wordpress::config inherits wordpress {

#Execute SQL password
exec { "mysqladmin -u root password 123@India && touch /tmp/flag1":
  path => "/usr/bin",
  creates => "/tmp/flag1",
  require => Package['mysql-client'],
}

#Run SQL commands
file { "/tmp/mysqlcommands":
  ensure => present,
  source => "puppet:///modules/wordpress/mysqlcommands",
  require => Exec['mysqladmin -u root password 123@India && touch /tmp/flag1']
}

#Execute the SQL commands
exec { "mysql -uroot -p123@India < /tmp/mysqlcommands && /tmp/flag2":
  path => "/usr/bin",
  creates => "/tmp/flag2",
  require => File['/tmp/mysqlcommands'],
}

#WGET WordPress archive
exec { 'get_wordpress_file':
  command => 'wget http://wordpress.org/latest.tar.gz -O /var/www/html/latest.tar.gz',
  path => '/sbin:/bin:/usr/sbin:/usr/bin',
  creates => '/var/www/html/latest.tar.gz',
  require => Package['php']
}

#Extract Wordpress archive
exec { 'tar -xvf /var/www/html/latest.tar.gz':
  path => '/sbin:/bin:/usr/sbin:/usr/bin',
  cwd => '/var/www/html/',
  creates => '/var/www/html/wordpress/index.php',
  require => Exec['get_wordpress_file']
}

#Recursively Copy wordpress content
file { '/var/www/html/':
  source => '/var/www/html/wordpress/',
  recurse => 'true',
  require => Exec['tar -xvf /var/www/html/latest.tar.gz']
}

#Remove the index.html file
file { '/var/www/html/index.html':
  ensure => 'absent',
  require => File['/var/www/html/']
}

#rename wp-config-sample.pgp
#edit wp-config.pgp
#Run SQL commands
file { '/var/www/html/wp-config.php':
  ensure => present,
  source => 'puppet:///modules/wordpress/wp-config.php',
  require => File['/var/www/html/index.html'],
}

}
