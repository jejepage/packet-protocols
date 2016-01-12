describe PacketProtocols::Icmp do
  let(:binary) {
    [
      0,         # type
      0,         # code
      0, 0,      # checksum
      0, 1,      # identifier
      0, 1,      # sequence_number
      1, 2, 3, 4 # data
    ].pack('C*')
  }

  it 'must read binary data' do
    icmp = PacketProtocols::Icmp.read(binary)
    expect(icmp.type).to eq(:echo_reply)
    expect(icmp.code).to eq(0)
    expect(icmp.checksum).to eq(0)
    expect(icmp.identifier).to eq(1)
    expect(icmp.sequence_number).to eq(1)
    expect(icmp.data).to eq([1, 2, 3, 4].pack('C*'))
    expect(icmp.to_binary_s).to eq(binary)
  end

  it 'must initialize with default values' do
    icmp = PacketProtocols::Icmp.new
    expect(icmp.type).to eq(:echo_request)
    expect(icmp.code).to eq(0)
    expect(icmp.checksum).to eq(0)
    expect(icmp.identifier).to eq(0)
    expect(icmp.sequence_number).to eq(0)
    expect(icmp.data).to be_empty
  end

  it 'must be able to change accessors' do
    icmp = PacketProtocols::Icmp.new
    icmp.type = :echo_reply
    expect(icmp.type).to eq(:echo_reply)
    icmp.data = [1, 2, 3, 4].pack('C*')
    expect(icmp.data).to eq([1, 2, 3, 4].pack('C*'))
  end

  it 'must initialize with options' do
    icmp = PacketProtocols::Icmp.new(type: :echo_reply, sequence_number: 123)
    expect(icmp.type).to eq(:echo_reply)
    expect(icmp.sequence_number).to eq(123)
  end
end
