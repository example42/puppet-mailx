# Puppet module: mailx

This is a Puppet module for mailx
It provides only package installation and file configuration.

Based on Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-mailx

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Basic management

* Install mailx with default settings

        class { 'mailx': }

* Install a specific version of mailx package

        class { 'mailx':
          version => '1.0.1',
        }

* Remove mailx resources

        class { 'mailx':
          absent => true
        }

* Enable auditing without without making changes on existing mailx configuration *files*

        class { 'mailx':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'mailx':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'mailx':
          source => [ "puppet:///modules/example42/mailx/mailx.conf-${hostname}" , "puppet:///modules/example42/mailx/mailx.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'mailx':
          source_dir       => 'puppet:///modules/example42/mailx/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'mailx':
          template => 'example42/mailx/mailx.conf.erb',
        }

* Automatically include a custom subclass

        class { 'mailx':
          my_class => 'example42::my_mailx',
        }



[![Build Status](https://travis-ci.org/example42/puppet-mailx.png?branch=master)](https://travis-ci.org/example42/puppet-mailx)
