Puppet::Type.newtype(:hash_file) do

  @doc = <<-EOS
    This type provides the capability to manage a file with json or yaml data in it
  EOS

  newparam(:path, :namevar => true) do
    desc "the path of the file - manage this separately with a file resource if you care about permissions and stuff"
  end

  newproperty(:value) do
    desc "the value that hash should be"
    defaultto {}
    validate do |value|
      unless value.is_a?(Hash)
        raise ArgumentError, "Path is not a fully qualified path: #{value}"
      end
    end
  end

end
