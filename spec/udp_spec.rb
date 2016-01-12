describe PacketProtocols::Udp do
  let(:binary) {
    [
      0, 10,     # source_port
      0, 20,     # destination_port
      0, 12,     # length
      0, 0,      # checksum
      1, 2, 3, 4 # payload
    ].pack('C*')
  }

  it 'must read binary data' do
    udp = PacketProtocols::Udp.read(binary)
    expect(udp.source_port).to eq(10)
    expect(udp.destination_port).to eq(20)
    expect(udp.length).to eq(12)
    expect(udp.checksum).to eq(0)
    expect(udp.payload).to eq([1, 2, 3, 4].pack('C*'))
    expect(udp.to_binary_s).to eq(binary)
  end

  it 'must initialize with default values' do
    udp = PacketProtocols::Udp.new
    expect(udp.source_port).to eq(0)
    expect(udp.destination_port).to eq(0)
    expect(udp.length).to eq(8)
    expect(udp.checksum).to eq(0)
    expect(udp.payload).to be_empty
  end

  it 'must be able to change accessors' do
    udp = PacketProtocols::Udp.new
    udp.destination_port = 20
    expect(udp.destination_port).to eq(20)
  end

  it 'must initialize with options' do
    udp = PacketProtocols::Udp.new(source_port: 10, payload: [1, 2].pack('C*'))
    expect(udp.source_port).to eq(10)
    expect(udp.length).to eq(10)
    expect(udp.payload).to eq([1, 2].pack('C*'))
  end
end
