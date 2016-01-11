require_relative 'lib/packet-protocols/version'

Gem::Specification.new do |s|
  s.name         = 'packet-protocols'
  s.version      = PacketProtocols::VERSION
  s.authors      = ['Jérémy Pagé']
  s.email        = ['contact@jeremypage.me']
  s.summary      = 'Packet Protocols'
  s.description  = 'A Parser/Serializer for Packet protocols.'

  s.files        = `git ls-files lib`.split("\n")
  s.test_files   = `git ls-files spec`.split("\n")
  s.require_path = 'lib'

  s.homepage     = 'https://github.com/jejepage/packet-protocols'
  s.license      = 'MIT'

  s.add_runtime_dependency 'bindata-contrib', '~> 0.1'
  s.add_development_dependency 'rspec', '~> 3.2'
end
