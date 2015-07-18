require 'bindata'

class MacAddress < BinData::Primitive
  endian :big
  array :octets, type: :uint8, initial_length: 6

  def get
    octets.map { |octet| format('%02x', octet) }.join(':')
  end

  def set(value)
    self.octets = value.split(':').map(&:hex)
  end
end
