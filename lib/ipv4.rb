require 'bindata-contrib'
require_relative 'icmp'
require_relative 'tcp'
require_relative 'udp'

class Ipv4 < BinData::Record
  PROTOCOLS = { icmp: 1, tcp: 6, udp: 17 }

  endian :big
  bit4 :version, asserted_value: 4
  bit4 :header_length, initial_value: 5
  bit6 :dscp
  bit2 :ecn
  uint16 :total_length, initial_value: -> { header_length_in_bytes + payload.length }
  uint16 :identifier
  bit1 :reserved
  bool :df
  bool :mf
  bit13 :fragment_offset
  uint8 :time_to_live, initial_value: 64
  enum8 :protocol, list: PROTOCOLS, initial_value: -> { :tcp }
  uint16 :checksum#, initial_value: :compute_checksum
  ipv4_address :ip_source
  ipv4_address :ip_destination
  string :options, read_length: :options_length_in_bytes
  choice :payload, selection: -> { protocol.to_s } do
    icmp 'icmp'
    tcp 'tcp'
    udp 'udp'
    rest :default
  end

  # virtual assert: :checksum_valid?

  def header_length_in_bytes
    header_length * 4
  end

  def options_length_in_bytes
    header_length_in_bytes - options.rel_offset
  end

  def length
    total_length
  end

  # def compute_checksum
  #   self.checksum = 0
  #   self.checksum = checksum_function
  # end
  #
  # def checksum_valid?
  #   checksum_function == 0
  # end

  # private
  #
  # def checksum_function
  #   bin = to_binary_s
  #   dbytes = bin.unpack('S>*')
  #   acc = dbytes.inject(:+)
  #   acc = ((acc >> 16) & 0xffff) + (acc & 0xffff)
  #   ~acc & 0xffff
  # end
end
