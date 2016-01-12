require 'bindata-contrib'

module PacketProtocols
  class Tcp < BinData::Record
    endian :big
    uint16 :source_port
    uint16 :destination_port
    uint32 :sequence_number
    uint32 :acknowledge_number
    bit4 :data_offset, initial_value: -> { 5 + options.length / 4 }
    bit3 :reserved
    bool :ns
    bool :cwr
    bool :ece
    bool :urg
    bool :ack
    bool :psh
    bool :rst
    bool :syn
    bool :fin
    uint16 :window_size
    uint16 :checksum#, initial_value: :compute_checksum
    uint16 :urgent_pointer
    string :options, read_length: :options_length_in_bytes
    rest :payload

    # virtual assert: :checksum_valid?

    def header_length_in_bytes
      data_offset * 4
    end

    def options_length_in_bytes
      header_length_in_bytes - options.rel_offset
    end

    def length
      header_length_in_bytes + options_length_in_bytes + payload.length
    end

    # def compute_checksum
    #   self.checksum = 0
    #   self.checksum = checksum_function
    # end
    #
    # def checksum_valid?
    #   checksum_function == 0
    # end
    #
    # private
    #
    # def checksum_function
    #   bin = to_binary_s
    #   dbytes = bin.unpack('S>*')
    #   acc = dbytes.inject(:+)
    #   acc = ((acc >> 16) & 0xffff) + (acc & 0xffff)
    #   ~acc & 0xffff
    # end

    # TODO: need IP parent for checksum
  end
end
