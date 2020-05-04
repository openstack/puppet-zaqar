require 'puppet'
require 'puppet/type/zaqar_config'
describe 'Puppet::Type.type(:zaqar_config)' do
  before :each do
    @zaqar_config = Puppet::Type.type(:zaqar_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:zaqar_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:zaqar_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:zaqar_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:zaqar_config).new(:name => 'DEFAULT/foo', :ensure => :absent)
  end

  it 'should accept a valid value' do
    @zaqar_config[:value] = 'bar'
    expect(@zaqar_config[:value]).to eq('bar')
  end

  it 'should not accept a value with whitespace' do
    @zaqar_config[:value] = 'b ar'
    expect(@zaqar_config[:value]).to eq('b ar')
  end

  it 'should accept valid ensure values' do
    @zaqar_config[:ensure] = :present
    expect(@zaqar_config[:ensure]).to eq(:present)
    @zaqar_config[:ensure] = :absent
    expect(@zaqar_config[:ensure]).to eq(:absent)
  end

  it 'should not accept invalid ensure values' do
    expect {
      @zaqar_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'zaqar::install::end')
    catalog.add_resource anchor, @zaqar_config
    dependency = @zaqar_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@zaqar_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
