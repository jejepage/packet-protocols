require 'packet-protocols/ipv4'
require 'packet-protocols/arp'

module PacketProtocols
  class Ethernet < BinData::Record
    PROTOCOLS = {
      ipv4: 0x0800,
      arp: 0x0806,
      vlan: 0x8100
    }

    endian :big
    mac_address 'mac_destination'
    mac_address 'mac_source'
    enum16 :protocol_internal, list: PROTOCOLS, initial_value: -> { :ipv4 }

    struct :vlan, onlyif: :has_vlan? do
      bit3 :pcp, initial_value: 0
      bit1 :cfi, initial_value: 0
      bit12 :id, initial_value: 0
      enum16 :protocol, list: PROTOCOLS, initial_value: -> { :ipv4 }
    end

    choice :payload, selection: -> { protocol.to_s } do
      ipv4 'ipv4'
      arp 'arp'
      rest :default
    end

    def has_vlan?
      protocol_internal == :vlan
    end

    def protocol
      has_vlan? ? vlan.protocol : protocol_internal
    end

    def length
      14 + (has_vlan? ? 4 : 0) + payload.length
    end
  end
end
