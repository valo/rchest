$: << File.join(File.dirname(__FILE__), 'lib')
require 'rchest'

chroot_box :ruby_box do
  root '/Users/valentinmihov/workspace/sandbox'
  user 'valentinmihov'
  group 'wheel'
  executables ['/usr/bin/ruby', '/bin/ls', '/bin/bash', '/usr/bin/whoami', '/usr/bin/id']
end

RChest.configure(:ruby_box)
RChest.chroot(:ruby_box)

exec '/bin/bash'