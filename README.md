RChest is a ruby tool for configuring and running chroot jails easily
=====================================================================

The idea is to define a chroot environments into a configuration file using a specialized DSL, then to configure the chroot and to run it.

Installation
------------

To be added

Supported OS
------------

Currently this is tested only on Mac OS X 10.6 and ubuntu linux. If someone try to use it on mac or linux and it is not working, please drop me a line.

Examples
--------

Create a new ruby script and drop this there

```ruby
require 'rchest'
    
chroot_folder :ruby_box do
  root '/home/valentinmihov/workspace/sandbox'
  user 'valentinmihov'
  group 'valentinmihov'
  executables ['/usr/bin/ruby', '/usr/bin/irb', '/bin/ls']
end
```
  
After that configure the chroot with

```bash
rake chroot:configure NAME=ruby_box
```
    
This is going to copy all the necessary files in order to run the executables into the chroot root directory
  
And run a command in the chroot

    rake chroot:run ruby_box '/usr/bin/ruby'
  
Another way is to directly invoke the RChest:

```ruby
require 'rchest'
    
chroot_folder :bash_box do
  root '/home/valentinmihov/workspace/sandbox'
  user 'valentinmihov'
  group 'valentinmihov'
  executables ['/bin/bash']
end
    
RChest.configure(:bash_box)
RChest.chroot(:bash_box)
    
exec '/bin/bash'
```
    
This example is going to configure a chroot environment in '/home/valentinmihov/workspace/sandbox', chroot with the specified user and group and start a bash shell.

The lib will make sure that the files in the chroot jail are owned by the specified user and group and also that the privileges are dropped permanently.
