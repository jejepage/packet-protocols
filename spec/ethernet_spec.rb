describe PacketProtocols::Ethernet do
  let(:binary) {
    [
      0, 0, 0, 0, 0, 2, # mac_destination
      0, 0, 0, 0, 0, 1, # mac_source
      0x81, 0,          # protocol

      # vlan
      0x20, 1, # pcp & cfi & vlan_id
      8, 6,    # protocol

      # arp
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
    eth = PacketProtocols::Ethernet.read(binary)
    expect(eth.mac_destination).to eq('00:00:00:00:00:02')
    expect(eth.mac_source).to eq('00:00:00:00:00:01')
    expect(eth.protocol).to eq(:arp)
    expect(eth.has_vlan?).to be true
    expect(eth.payload.hardware).to eq(:ethernet)
    expect(eth.payload.ip_source).to eq('192.168.0.1')
    expect(eth.to_binary_s).to eq(binary)
  end

  it 'must initialize with default values' do
    eth = PacketProtocols::Ethernet.new
    expect(eth.mac_destination).to eq('00:00:00:00:00:00')
    expect(eth.mac_source).to eq('00:00:00:00:00:00')
    expect(eth.protocol).to eq(:ipv4)
    expect(eth.payload.protocol).to eq(:tcp)
    expect(eth.length).to eq(54)
  end

  it 'must be able to change accessors' do
    eth = PacketProtocols::Ethernet.new
    eth.mac_destination = '00:00:00:00:00:02'
    expect(eth.mac_destination).to eq('00:00:00:00:00:02')
  end

  it 'must initialize with options' do
    eth = PacketProtocols::Ethernet.new(mac_destination: '00:00:00:00:00:02')
    expect(eth.mac_destination).to eq('00:00:00:00:00:02')
  end
end


# require 'spec_helper'
#
# describe PacketProtocols::Ethernet do
#   it 'should read an unkown protocol' do
#     packet = PacketProtocols::Ethernet.read [
#       0, 0, 0, 0, 0, 2, # mac_destination
#       0, 0, 0, 0, 0, 1, # mac_source
#       0, 0              # protocol
#     ].pack('C*')
#     expect(packet.mac_destination).to eq('00:00:00:00:00:02')
#     expect(packet.mac_source).to eq('00:00:00:00:00:01')
#     expect(packet.protocol).to eq(0)
#     expect(packet.payload).to be_empty
#   end
#
#   it 'should read a VLAN packet' do
#     packet = PacketProtocols::Ethernet.read [
#       0, 0, 0, 0, 0, 2, # mac_destination
#       0, 0, 0, 0, 0, 1, # mac_source
#       0x81, 0,          # protocol
#
#       # vlan
#       0x20, 1, # pcp & cfi & vlan_id
#       0, 0     # protocol
#     ].pack('C*')
#     expect(packet.mac_destination).to eq('00:00:00:00:00:02')
#     expect(packet.mac_source).to eq('00:00:00:00:00:01')
#     expect(packet.protocol).to eq(0)
#     expect(packet.payload).to be_empty
#     expect(packet.vlan.pcp).to eq(1)
#     expect(packet.vlan.cfi).to eq(0)
#     expect(packet.vlan.id).to eq(1)
#   end
#
#   describe 'with ARP' do
#     it 'should read binary' do
#       packet = PacketProtocols::Ethernet.read [
#         0, 0, 0, 0, 0, 2, # mac_destination
#         0, 0, 0, 0, 0, 1, # mac_source
#         8, 6,             # protocol
#
#         # arp
#         0, 1,             # hardware
#         8, 0,             # protocol
#         6,                # hardware_length
#         4,                # protocol_length
#         0, 2,             # operation
#         0, 0, 0, 0, 0, 1, # mac_source
#         192, 168, 0, 1,   # ip_source
#         0, 0, 0, 0, 0, 2, # mac_destination
#         192, 168, 0, 2    # ip_destination
#       ].pack('C*')
#       expect(packet.mac_destination).to eq('00:00:00:00:00:02')
#       expect(packet.mac_source).to eq('00:00:00:00:00:01')
#       expect(packet.protocol).to eq(:arp)
#       expect(packet.payload.hardware).to eq(:ethernet)
#       expect(packet.payload.protocol).to eq(:ipv4)
#       expect(packet.payload.hardware_length).to eq(6)
#       expect(packet.payload.protocol_length).to eq(4)
#       expect(packet.payload.operation).to eq(:reply)
#       expect(packet.payload.mac_source).to eq('00:00:00:00:00:01')
#       expect(packet.payload.ip_source).to eq('192.168.0.1')
#       expect(packet.payload.mac_destination).to eq('00:00:00:00:00:02')
#       expect(packet.payload.ip_destination).to eq('192.168.0.2')
#     end
#   end
#
#   describe 'with IPv4/TCP' do
#     it 'should read binary' do
#       packet = PacketProtocols::Ethernet.read [
#         0, 0, 0, 0, 0, 2, # mac_destination
#         0, 0, 0, 0, 0, 1, # mac_source
#         8, 0,             # protocol
#
#         # ipv4
#         0x45,           # version & header_length
#         7,              # tos
#         0, 44,          # total_length
#         0, 1,           # identifier
#         0, 0,           # flags & fragment_offset
#         64,             # time_to_live
#         6,              # protocol
#         0x73, 0x04,     # checksum
#         192, 168, 0, 1, # ip_source
#         192, 168, 0, 2, # ip_destination
#
#         # tcp
#         0x10, 0,    # source_port
#         0x20, 0,    # destination_port
#         0, 0, 0, 1, # sequence_number
#         0, 0, 0, 2, # acknowledge_number
#         0x51, 0xff, # data_offset &
#         0, 100,     # window_size
#         0, 0,       # checksum
#         0, 0,       # urgent_pointer
#         1, 2, 3, 4  # payload
#       ].pack('C*')
#       expect(packet.mac_destination).to eq('00:00:00:00:00:02')
#       expect(packet.mac_source).to eq('00:00:00:00:00:01')
#       expect(packet.protocol).to eq(:ipv4)
#       expect(packet.payload.version).to eq(4)
#       expect(packet.payload.header_length).to eq(5)
#       expect(packet.payload.tos).to eq(7)
#       expect(packet.payload.total_length).to eq(44)
#       expect(packet.payload.identifier).to eq(1)
#       expect(packet.payload.flags).to eq(0)
#       expect(packet.payload.fragment_offset).to eq(0)
#       expect(packet.payload.time_to_live).to eq(64)
#       expect(packet.payload.protocol).to eq(:tcp)
#       expect(packet.payload.checksum).to eq(0x7304)
#       expect(packet.payload.ip_source).to eq('192.168.0.1')
#       expect(packet.payload.ip_destination).to eq('192.168.0.2')
#       expect(packet.payload.options).to be_empty
#       expect(packet.payload.payload.source_port).to eq(0x1000)
#       expect(packet.payload.payload.destination_port).to eq(0x2000)
#       expect(packet.payload.payload.sequence_number).to eq(1)
#       expect(packet.payload.payload.acknowledge_number).to eq(2)
#       expect(packet.payload.payload.data_offset).to eq(5)
#       expect(packet.payload.payload.ns).to eq(1)
#       expect(packet.payload.payload.cwr).to eq(1)
#       expect(packet.payload.payload.ece).to eq(1)
#       expect(packet.payload.payload.urg).to eq(1)
#       expect(packet.payload.payload.ack).to eq(1)
#       expect(packet.payload.payload.psh).to eq(1)
#       expect(packet.payload.payload.rst).to eq(1)
#       expect(packet.payload.payload.syn).to eq(1)
#       expect(packet.payload.payload.fin).to eq(1)
#       expect(packet.payload.payload.window_size).to eq(100)
#       expect(packet.payload.payload.checksum).to eq(0)
#       expect(packet.payload.payload.urgent_pointer).to eq(0)
#       expect(packet.payload.payload.options).to be_empty
#       expect(packet.payload.payload.payload).to eq([1, 2, 3, 4].pack('C*'))
#     end
#   end
#
#   describe 'with IPv4/UDP' do
#     it 'should read binary' do
#       packet = PacketProtocols::Ethernet.read [
#         0, 0, 0, 0, 0, 2, # mac_destination
#         0, 0, 0, 0, 0, 1, # mac_source
#         8, 0,             # protocol
#
#         # ipv4
#         0x45,           # version & header_length
#         7,              # tos
#         0, 44,          # total_length
#         0, 1,           # identifier
#         0, 0,           # flags & fragment_offset
#         64,             # time_to_live
#         17,             # protocol
#         0xc5, 0x5b,     # checksum
#         192, 168, 0, 1, # ip_source
#         192, 168, 0, 2, # ip_destination
#
#         # udp
#         0x10, 0,   # source_port
#         0x20, 0,   # destination_port
#         0, 4,      # len
#         0, 0,      # checksum
#         1, 2, 3, 4 # payload
#       ].pack('C*')
#       expect(packet.mac_destination).to eq('00:00:00:00:00:02')
#       expect(packet.mac_source).to eq('00:00:00:00:00:01')
#       expect(packet.protocol).to eq(:ipv4)
#       expect(packet.payload.version).to eq(4)
#       expect(packet.payload.header_length).to eq(5)
#       expect(packet.payload.tos).to eq(7)
#       expect(packet.payload.total_length).to eq(44)
#       expect(packet.payload.identifier).to eq(1)
#       expect(packet.payload.flags).to eq(0)
#       expect(packet.payload.fragment_offset).to eq(0)
#       expect(packet.payload.time_to_live).to eq(64)
#       expect(packet.payload.protocol).to eq(:udp)
#       expect(packet.payload.checksum).to eq(0xc55b)
#       expect(packet.payload.ip_source).to eq('192.168.0.1')
#       expect(packet.payload.ip_destination).to eq('192.168.0.2')
#       expect(packet.payload.options).to be_empty
#       expect(packet.payload.payload.source_port).to eq(0x1000)
#       expect(packet.payload.payload.destination_port).to eq(0x2000)
#       expect(packet.payload.payload.len).to eq(4)
#       expect(packet.payload.payload.checksum).to eq(0)
#       expect(packet.payload.payload.payload).to eq([1, 2, 3, 4].pack('C*'))
#     end
#   end
#
#   describe 'with IPv4/ICMP' do
#     it 'should read binary' do
#       packet = PacketProtocols::Ethernet.read [
#         0, 0, 0, 0, 0, 2, # mac_destination
#         0, 0, 0, 0, 0, 1, # mac_source
#         8, 0,             # protocol
#
#         # ipv4
#         0x45,           # version & header_length
#         7,              # tos
#         0, 44,          # total_length
#         0, 1,           # identifier
#         0, 0,           # flags & fragment_offset
#         64,             # time_to_live
#         1,              # protocol
#         0xf5, 0x6d,     # checksum
#         192, 168, 0, 1, # ip_source
#         192, 168, 0, 2, # ip_destination
#
#         # icmp
#         0,         # type
#         0,         # code
#         0, 0,      # checksum
#         0, 1,      # identifier
#         0, 1,      # sequence_number
#         1, 2, 3, 4 # data
#       ].pack('C*')
#       expect(packet.mac_destination).to eq('00:00:00:00:00:02')
#       expect(packet.mac_source).to eq('00:00:00:00:00:01')
#       expect(packet.protocol).to eq(:ipv4)
#       expect(packet.payload.version).to eq(4)
#       expect(packet.payload.header_length).to eq(5)
#       expect(packet.payload.tos).to eq(7)
#       expect(packet.payload.total_length).to eq(44)
#       expect(packet.payload.identifier).to eq(1)
#       expect(packet.payload.flags).to eq(0)
#       expect(packet.payload.fragment_offset).to eq(0)
#       expect(packet.payload.time_to_live).to eq(64)
#       expect(packet.payload.protocol).to eq(:icmp)
#       expect(packet.payload.checksum).to eq(0xf56d)
#       expect(packet.payload.ip_source).to eq('192.168.0.1')
#       expect(packet.payload.ip_destination).to eq('192.168.0.2')
#       expect(packet.payload.options).to be_empty
#       expect(packet.payload.payload.type).to eq(:echo_reply)
#       expect(packet.payload.payload.code).to eq(0)
#       expect(packet.payload.payload.checksum).to eq(0)
#       expect(packet.payload.payload.identifier).to eq(1)
#       expect(packet.payload.payload.sequence_number).to eq(1)
#       expect(packet.payload.payload.data).to eq([1, 2, 3, 4].pack('C*'))
#     end
#   end
# end
