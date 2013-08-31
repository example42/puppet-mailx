# Class: mailx::params
#
# This class defines default parameters used by the main module class mailx
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to mailx class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class mailx::params {

  ### Application related parameters

  $package = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint)/ => 'bsd-mailx',
    default => 'mailx',
  }

  $config_dir = $::operatingsystem ? {
    default => '',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/mail.rc',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $version = 'present'
  $absent = false
  $audit_only = false
  $noops = undef

}
