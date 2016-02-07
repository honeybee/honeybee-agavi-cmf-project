require 'puppet/util'
require 'fileutils'
require 'puppet/util/symbolic_file_mode'
Puppet::Type.type(:hash_file).provide(:json) do

  include Puppet::Util::SymbolicFileMode

  begin
    require 'json'
    confine :true => true
    defaultfor :feature => :posix
    defaultfor :feature => :windows
  rescue LoadError 
    # mark the provider as unsuitable - there has to be a better way that this, but hacksy hacksy
    confine :true => false
  end

  def exists?
    File.exists?(@resource[:path])
  end

  def destroy
    File.delete(@resource[:path])
  end

  def create
    Puppet::Util.withumask(umask) { ::File.open(self[:path], 'wb', mode_int ) { |f| write_content(f.to_json) } }
  end

  def value
    begin
      JSON::parse File.read @resource[:path] if File.exists?(@resource[:path])
    rescue JSON::ParserError
      nil
    rescue Errno::ENOENT
      Puppet.debug "Could not open #{@resource[:path]}"
    end
  end

  def value=(thehash)
    mode_int = mode ? symbolic_mode_to_int(mode, Puppet::Util::DEFAULT_POSIX_MODE) : nil
    Puppet.debug "mode_int is : mode_int"
    Puppet::Util.replace_file(@resource[:path], mode_int) do |file|
      file.binmode
      file.write thehash.to_json
      file.flush
    end
  end
  def umask
    umask = mode ? 000 : 022
  end
  def mode
    '0644'
  end

end
