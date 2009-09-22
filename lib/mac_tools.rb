module MacTools
  def get_dependencies(object)
    return [] if !is_executable_or_lib(object)
    
    %x{otool -L #{object}}.split($/)[1..-1].map { |line| line.strip[%r{^(.+) \(compatibility}, 1] }
  end
  
  def is_executable_or_lib(object)
    !(%x{otool -L #{object}} =~ /is not an object file/)
  end
  
  def is_text_script(object)
    %x{file #{object}} =~ /script text/
  end
end