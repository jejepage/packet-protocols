require 'bindata'

module PacketProtocols
  class Udp < BinData::Record
    endian :big
    uint16 :source_port
    uint16 :destination_port
    uint16 :len, initial_value: -> { 8 + payload.length }
    uint16 :checksum
    rest :payload

    def length
      len
    end
  end
end
