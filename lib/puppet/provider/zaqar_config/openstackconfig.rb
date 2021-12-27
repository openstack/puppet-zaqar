Puppet::Type.type(:zaqar_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/zaqar/zaqar.conf'
  end

end
