$:.push File.expand_path("../../lib", __FILE__)
require 'simple_asm'

s = SimpleAsm::Simple.new do
  add 1, 0
  sub 0, 1
  ld 1, 0, 111
  st 0, 1, 101
end

puts s.to_s
