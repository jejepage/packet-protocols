describe PacketProtocols::Arp do
  let(:binary) {
    [
      0, 1,             # hardware
      8, 0,             # protocol
      6,                # hardware_length
      4,                # protocol_length
      0, 2,             # operation
      0, 0, 0, 0, 0, 1, # mac_source
      192, 168, 0, 1,   # ip_source
      0, 0, 0, 0, 0, 2, # mac_destination
      192, 168, 0, 2    # ip_destination
    ].pack('C*')
  }

  it 'must read binary data' do
    arp = PacketProtocols::Arp.read(binary)
    expect(arp.hardware).to eq(:ethernet)
    expect(arp.protocol).to eq(:ipv4)
    expect(arp.hardware_length).to eq(6)
    expect(arp.protocol_length).to eq(4)
    expect(arp.operation).to eq(:reply)
    expect(arp.mac_source).to eq('00:00:00:00:00:01')
    expect(arp.ip_source).to eq('192.168.0.1')
    expect(arp.mac_destination).to eq('00:00:00:00:00:02')
    expect(arp.ip_destination).to eq('192.168.0.2')
    expect(arp.to_binary_s).to eq(binary)
  end

  it 'must initialize with default values' do
    arp = PacketProtocols::Arp.new
    expect(arp.hardware).to eq(:ethernet)
    expect(arp.protocol).to eq(:ipv4)
    expect(arp.hardware_length).to eq(6)
    expect(arp.protocol_length).to eq(4)
    expect(arp.operation).to eq(:request)
    expect(arp.mac_source).to eq('00:00:00:00:00:00')
    expect(arp.ip_source).to eq('0.0.0.0')
    expect(arp.mac_destination).to eq('00:00:00:00:00:00')
    expect(arp.ip_destination).to eq('0.0.0.0')
  end

  it 'must be able to change accessors' do
    arp = PacketProtocols::Arp.new
    arp.operation = :reply
    expect(arp.operation).to eq(:reply)
    arp.mac_source = '01:23:45:67:89:01'
    expect(arp.mac_source).to eq('01:23:45:67:89:01')
    arp.ip_source = '128.0.0.1'
    expect(arp.ip_source).to eq('128.0.0.1')
  end

  it 'must initialize with options' do
    arp = PacketProtocols::Arp.new(operation: :reply, ip_source: '192.168.0.1')
    expect(arp.operation).to eq(:reply)
    expect(arp.ip_source).to eq('192.168.0.1')
  end
end
