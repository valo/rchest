require 'set'
require 'etc'
require 'fileutils'

if RUBY_PLATFORM =~ /darwin/
  require File.join(File.dirname(__FILE__), 'mac_tools')
elsif RUBY_PLATFORM =~ /linux/i
  require File.join(File.dirname(__FILE__), 'linux_tools')
else
  raise "Unsupported platform! Currently RChest support only Mac OS X and Linux"
end


class RChest
  class << self
    if RUBY_PLATFORM =~ /darwin/
      include MacTools
    else
      include LinuxTools
    end
    attr_accessor :chroot_box
    attr_accessor :boxes
    
    def configure(name)
      box = verify_chroot(name)
      if !File.exists?(box.root)
        puts "Creating root #{box.root}..."
        FileUtils.mkdir_p(box.root)
      end

      raise "The root #{box.root} is not a directory" unless File.directory?(box.root)

      visited = Set.new

      box.executables.each do |object|
        process(object, visited, box)
      end
    end
    
    def chroot(name)
      box = verify_chroot(name)
      
      Dir.chdir box.root
      FileUtils.chown_R box.user, box.group, '.', :verbose => true
      gid = Etc.getgrnam(box.group).gid
      uid = Etc.getpwnam(box.user).uid
      Dir.chroot box.root
      Process::Sys.setgid(gid)
      Process::Sys.setuid(uid)
    end
    
    private
      def verify_chroot(name)
        RChest.boxes[name.to_s] or raise "Cannot find a box with name #{name.to_s}"
      end

      def process(object, visited, box)
        object = File.expand_path(object)
        return if visited.include?(object)

        if !File.exists?(object)
          puts "Cannot find file #{object}. Skipping..."
          return
        end

        cp_dest = File.join(box.root, object[1..-1])
        puts "Copying #{object} to #{cp_dest}"
        FileUtils.mkdir_p(File.dirname(cp_dest)) unless File.directory?(File.dirname(cp_dest))
        FileUtils.cp(object, cp_dest) unless File.exists?(cp_dest)

        visited << object

        if !RChest.is_executable_or_lib(object)
          # Try to see if this is a script file
          if RChest.is_text_script(object)
            first_line = File.open(object, "r").readline
            if first_line =~ /#!(.+)/
              puts "#{object} is script that uses #{$1} to execute"
              process($1, visited, box)
            end
          else
            puts "Cannot determine the type of #{object}. Probably it won't work in the chroot"
            return
          end
        else
          RChest.get_dependencies(object).each do |dep|
            process(dep, visited, box)
          end
        end
      end
  end

  attr_accessor :name, :root, :user, :executables, :group

  def initialize(name)
    @name = name
    
    if RUBY_PLATFORM =~ /darwin/
      @executables = ['/usr/lib/dyld']
    end
  end
end

def chroot_box(name, &block)
  RChest.chroot_box = RChest.new(name.to_s)
  
  yield
  
  RChest.boxes ||= {}
  RChest.boxes[RChest.chroot_box.name] = RChest.chroot_box
  RChest.chroot_box = nil
end

[:root, :user, :group].each do |method|
  eval <<EVALSTART
  def #{method}(value)
    RChest.chroot_box.#{method.to_s} = value
  end
EVALSTART
end

def executables(execs)
  RChest.chroot_box.executables ||= []
  RChest.chroot_box.executables += execs
end
