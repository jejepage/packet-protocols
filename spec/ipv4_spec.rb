describe PacketProtocols::Ipv4 do
  let(:binary) {
    [
      0x45,           # version & header_length
      0xe0,           # dscp & ecn
      0, 32,          # total_length
      0, 1,           # identifier
      0, 0,           # flags & fragment_offset
      64,             # time_to_live
      17,             # protocol
      0xc5, 0x5b,     # checksum
      192, 168, 0, 1, # ip_source
      192, 168, 0, 2, # ip_destination

      # udp
      0, 10,     # source_port
      0, 20,     # destination_port
      0, 12,     # len
      0, 0,      # checksum
      1, 2, 3, 4 # payload
    ].pack('C*')
  }

  it 'must read binary data' do
    ipv4 = PacketProtocols::Ipv4.read(binary)
    expect(ipv4.version).to eq(4)
    expect(ipv4.header_length).to eq(5)
    expect(ipv4.dscp).to eq(56)
    expect(ipv4.ecn).to eq(0)
    expect(ipv4.total_length).to eq(32)
    expect(ipv4.identifier).to eq(1)
    expect(ipv4.df).to eq(false)
    expect(ipv4.mf).to eq(false)
    expect(ipv4.fragment_offset).to eq(0)
    expect(ipv4.time_to_live).to eq(64)
    expect(ipv4.protocol).to eq(:udp)
    expect(ipv4.checksum).to eq(0xc55b)
    expect(ipv4.ip_source).to eq('192.168.0.1')
    expect(ipv4.ip_destination).to eq('192.168.0.2')
    expect(ipv4.options).to be_empty
    expect(ipv4.payload.source_port).to eq(10)
    expect(ipv4.to_binary_s).to eq(binary)
  end

  it 'must initialize with default values' do
    ipv4 = PacketProtocols::Ipv4.new
    expect(ipv4.version).to eq(4)
    expect(ipv4.header_length).to eq(5)
    expect(ipv4.dscp).to eq(0)
    expect(ipv4.ecn).to eq(0)
    expect(ipv4.total_length).to eq(40)
    expect(ipv4.identifier).to eq(0)
    expect(ipv4.df).to eq(false)
    expect(ipv4.mf).to eq(false)
    expect(ipv4.fragment_offset).to eq(0)
    expect(ipv4.time_to_live).to eq(64)
    expect(ipv4.protocol).to eq(:tcp)
    expect(ipv4.checksum).to eq(0)
    expect(ipv4.ip_source).to eq('0.0.0.0')
    expect(ipv4.ip_destination).to eq('0.0.0.0')
    expect(ipv4.options).to be_empty
    expect(ipv4.payload.source_port).to eq(0)
  end

  it 'must be able to change accessors' do
    ipv4 = PacketProtocols::Ipv4.new
    ipv4.identifier = 10
    expect(ipv4.identifier).to eq(10)
  end

  it 'must initialize with options' do
    ipv4 = PacketProtocols::Ipv4.new(identifier: 10)
    expect(ipv4.identifier).to eq(10)
  end
end
