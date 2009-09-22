RChest is a ruby tool for making running programs in chroot easier
------------------------------------------------------------------

The idea is to define a chroot environments into a configuration file using a specialized DSL, then to configure the chroot and to run it.

Examples
========

    chroot_folder :ruby_box do
      root '/home/valentinmihov/workspace/sandbox'
      user 'valentinmihov'
      executables ['/usr/bin/ruby', '/usr/bin/irb', '/bin/ls']
    end
  
After that configure the chroot with
  
    rake chroot:configure NAME=ruby_box
  
And run a command in the chroot

    rake chroot:run ruby_box '/usr/bin/ruby'
  
Another way is to directly invoke the RChest:

    chroot_folder :bash_box do
      root '/home/valentinmihov/workspace/sandbox'
      user 'valentinmihov'
      executables ['/usr/bin/bash']
    end
    
    RChest.configure(:bash_box)
    RChest.chroot(:bash_box)
    
    exec '/bin/bash'
    
This example is going to configure a chroot environment in '/home/valentinmihov/workspace/sandbox', chroot with the specified user and start bash shell.