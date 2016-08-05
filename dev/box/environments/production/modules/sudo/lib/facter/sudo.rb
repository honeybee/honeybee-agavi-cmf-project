Facter.add("sudoversion") do
  confine :kernel => 'Linux'
  setcode do
    ENV["PATH"]="/bin:/sbin:/usr/bin:/usr/sbin"
    output = `sudo -V 2>&1`
    if $?.exitstatus.zero?
      m = /Sudo version ([\d\.]+)/.match output
      if m
        m[1]
      end
    end
  end
end
