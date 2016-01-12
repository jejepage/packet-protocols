require 'bindata-contrib'

module PacketProtocols
  class Arp < BinData::Record
    HARDWARES = { ethernet: 1 }
    PROTOCOLS = { ipv4: 0x0800 }
    OPERATIONS = { request: 1, reply: 2 }

    endian :big
    enum16 :hardware, list: HARDWARES, initial_value: -> { :ethernet }
    enum16 :protocol, list: PROTOCOLS, initial_value: -> { :ipv4 }
    uint8 :hardware_length, initial_value: 6
    uint8 :protocol_length, initial_value: 4
    enum16 :operation, list: OPERATIONS, initial_value: -> { :request }
    mac_address :mac_source, onlyif: :ipv4_in_ethernet?
    ipv4_address :ip_source, onlyif: :ipv4_in_ethernet?
    mac_address :mac_destination, onlyif: :ipv4_in_ethernet?
    ipv4_address :ip_destination, onlyif: :ipv4_in_ethernet?

    virtual assert: (proc do
      !ipv4_in_ethernet? || (hardware_length == 6 && protocol_length == 4)
    end)

    def ipv4_in_ethernet?
      hardware == :ethernet && protocol == :ipv4
    end

    def length
      28
    end
  end
end
