require 'rubygems'
require 'rake'
require 'set'
require 'etc'

require 'chroot_config'

namespace :chroot do
  desc "Configure chroot"
  task :configure do
    RChest.configure(ENV['NAME'])
  end
  
  desc "Run an executable in the chroot environment"
  task :run do
    RChest.chroot(ENV['NAME'])
    exec ENV['CMD']
  end
end
