#####################################################
# hysds_dev class
#####################################################

class hysds_dev inherits hysds_base {

  #####################################################
  # install packages
  #####################################################

  yumgroup { 'Development tools':
    ensure  => present,
  }

  package {
    'openldap-devel': ensure => installed;
    'geos-devel': ensure => installed;
    'proj-devel': ensure => installed;
    'Cython': ensure => installed;
  }


}
