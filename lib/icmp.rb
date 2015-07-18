require 'bindata-contrib'

class Icmp < BinData::Record
  TYPES = { echo_reply: 0, echo_request: 8 }

  endian :big
  enum8 :type, list: TYPES, initial_value: -> { :echo_request }
  uint8 :code, initial_value: 0
  uint16 :checksum

  uint16 :identifier, onlyif: :echo?
  uint16 :sequence_number, onlyif: :echo?
  rest :data, onlyif: :echo?

  def echo?
    type == :echo_request || type == :echo_reply
  end

  def length
    4 + (echo? ? 4 + data.length : 0)
  end
end
