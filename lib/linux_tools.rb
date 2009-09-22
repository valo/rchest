module LinuxTools
  def get_dependencies(object)
    return [] if !is_executable_or_lib(object)
    
    %x{ldd #{object}}.split($/).map { |line| line.strip[%r{(^|=> )(/.+) \(0x}, 2] }.compact
  end
  
  def is_executable_or_lib(object)
    !(%x{ldd #{object}} =~ /not a dynamic executable/)
  end
  
  def is_text_script(object)
    %x{file #{object}} =~ /script text/
  end
end
