require 'bindata'

class Ipv4Address < BinData::Primitive
  endian :big
  array :octets, type: :uint8, initial_length: 4

  def get
    octets.map(&:to_s).join('.')
  end

  def set(value)
    self.octets = value.split('.').map(&:to_i)
  end
end
