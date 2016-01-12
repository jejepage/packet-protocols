describe PacketProtocols::Tcp do
  let(:binary) {
    [
      0, 10,      # source_port
      0, 20,      # destination_port
      0, 0, 0, 1, # sequence_number
      0, 0, 0, 2, # acknowledge_number
      0x51, 0xff, # data_offset & flags
      0, 100,     # window_size
      0, 0,       # checksum
      0, 0,       # urgent_pointer
      1, 2, 3, 4  # payload
    ].pack('C*')
  }

  it 'must read binary data' do
    tcp = PacketProtocols::Tcp.read(binary)
    expect(tcp.source_port).to eq(10)
    expect(tcp.destination_port).to eq(20)
    expect(tcp.sequence_number).to eq(1)
    expect(tcp.acknowledge_number).to eq(2)
    expect(tcp.data_offset).to eq(5)
    expect(tcp.ns).to eq(true)
    expect(tcp.cwr).to eq(true)
    expect(tcp.ece).to eq(true)
    expect(tcp.urg).to eq(true)
    expect(tcp.ack).to eq(true)
    expect(tcp.psh).to eq(true)
    expect(tcp.rst).to eq(true)
    expect(tcp.syn).to eq(true)
    expect(tcp.fin).to eq(true)
    expect(tcp.window_size).to eq(100)
    expect(tcp.checksum).to eq(0)
    expect(tcp.urgent_pointer).to eq(0)
    expect(tcp.options).to be_empty
    expect(tcp.payload).to eq([1, 2, 3, 4].pack('C*'))
    expect(tcp.to_binary_s).to eq(binary)
  end

  it 'must initialize with default values' do
    tcp = PacketProtocols::Tcp.new
    expect(tcp.source_port).to eq(0)
    expect(tcp.data_offset).to eq(5)
  end

  it 'must be able to change accessors' do
    tcp = PacketProtocols::Tcp.new
    tcp.source_port = 10
    expect(tcp.source_port).to eq(10)
  end

  it 'must initialize with options' do
    tcp = PacketProtocols::Tcp.new(source_port: 10, options: [1, 2, 3, 4].pack('C*'))
    expect(tcp.source_port).to eq(10)
    expect(tcp.data_offset).to eq(6)
    expect(tcp.options).to eq([1, 2, 3, 4].pack('C*'))
  end
end
