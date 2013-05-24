$:.push File.expand_path("../../lib", __FILE__)
require 'simple_asm'
include SimpleAsm

s = Simple.new do
  add r0, r1
  sub 0, 1
  ld 1, 0, 111
  st 0, 1, 101
  li 1, 10
  b 2, 11
  be 255
end

puts s.to_s
