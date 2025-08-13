if versioncmp($::puppetversion,'3.6.1') >= 0 {

  $allow_virtual_packages = lookup('allow_virtual_packages', undef, undef, false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

class microdnf {
  exec { "microdnf-update":
    command => "microdnf -y update"
  }
}

node 'default' {

  # define stages
  stage {
    'pre' : ;
    'post': ;
  }

  # specify stage that each class belongs to;
  # if not specified, they belong to Stage[main]
  class {
    'microdnf':         stage => 'pre';
  }

  # stage order
  Stage['pre'] -> Stage[main] -> Stage['post']

  # modules
  include hysds_base
  include hysds_dev

}
