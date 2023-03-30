# Installation d'Apache
class { 'apache':
  mpm_module => 'prefork',
  default_vhost => false,
}

# Installation de MySQL et création d'une base de données et d'un utilisateur pour WordPress
class { 'mysql::server':
  root_password           => 'votre_mot_de_passe_ic',
  remove_anonymous_users  => true,
  remove_test_database    => true,
}
mysql::db { 'wordpress':
  user     => 'utilisateur_wordpress',
  password => 'votre_mot_de_passe_wordpress_ic',
}

# Installation de PHP et des modules requis pour WordPress
class { 'php':
  package_prefix => 'php7.4',
  modules        => ['curl', 'gd', 'mysql', 'xml'],
}
class { 'apache::mod::php':
  php_version => '7.4',
}

# Installation de WordPress
class { 'wordpress':
  version    => '5.7.1',
  db_name    => 'wordpress',
  db_user    => 'utilisateur_wordpress',
  db_password => 'votre_mot_de_passe_wordpress_ic',
  db_host    => 'localhost',
  install_dir => '/var/www/wordpress',
}

# Configuration d'Apache pour servir WordPress
apache::vhost { 'wordpress.exemple':
  servername      => 'wordpress.exemple',
  serveraliases   => ['www.wordpress.exemple'],
  docroot         => '/var/www/wordpress',
  directories     => [
    {
      'path'     => '/var/www/wordpress',
      'options'  => 'Indexes FollowSymLinks',
      'allow'    => 'all',
      'override' => ['All'],
    },
  ],
}
