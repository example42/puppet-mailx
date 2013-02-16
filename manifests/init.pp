# = Class: mailx
#
# This is the main mailx class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, mailx class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $mailx_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, mailx main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $mailx_source
#
# [*source_dir*]
#   If defined, the whole mailx configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $mailx_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $mailx_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, mailx main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $mailx_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $mailx_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $mailx_absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $mailx_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#
# Default class params - As defined in mailx::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of mailx package
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include mailx"
# - Call mailx as a parametrized class
#
# See README for details.
#
#
class mailx (
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $package             = params_lookup( 'package' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' )
  ) inherits mailx::params {

  $config_file_mode=$mailx::params::config_file_mode
  $config_file_owner=$mailx::params::config_file_owner
  $config_file_group=$mailx::params::config_file_group

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_absent=any2bool($absent)
  $bool_audit_only=any2bool($audit_only)
  $bool_noops=any2bool($noops)

  ### Definition of some variables used in the module
  $manage_package = $mailx::bool_absent ? {
    true  => 'absent',
    false => $mailx::version,
  }

  $manage_file = $mailx::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_audit = $mailx::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $mailx::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $mailx::source ? {
    ''        => undef,
    default   => $mailx::source,
  }

  $manage_file_content = $mailx::template ? {
    ''        => undef,
    default   => template($mailx::template),
  }

  ### Managed resources
  package { $mailx::package:
    ensure  => $mailx::manage_package,
    noop    => $mailx::bool_noops,
  }

  file { 'mailx.conf':
    ensure  => $mailx::manage_file,
    path    => $mailx::config_file,
    mode    => $mailx::config_file_mode,
    owner   => $mailx::config_file_owner,
    group   => $mailx::config_file_group,
    require => Package[$mailx::package],
    source  => $mailx::manage_file_source,
    content => $mailx::manage_file_content,
    replace => $mailx::manage_file_replace,
    audit   => $mailx::manage_audit,
    noop    => $mailx::bool_noops,
  }

  # The whole mailx configuration directory can be recursively overriden
  if $mailx::source_dir {
    file { 'mailx.dir':
      ensure  => directory,
      path    => $mailx::config_dir,
      require => Package[$mailx::package],
      notify  => $mailx::manage_service_autorestart,
      source  => $mailx::source_dir,
      recurse => true,
      purge   => $mailx::bool_source_dir_purge,
      force   => $mailx::bool_source_dir_purge,
      replace => $mailx::manage_file_replace,
      audit   => $mailx::manage_audit,
      noop    => $mailx::bool_noops,
    }
  }


  ### Include custom class if $my_class is set
  if $mailx::my_class {
    include $mailx::my_class
  }

}
