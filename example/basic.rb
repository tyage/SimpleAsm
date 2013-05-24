$:.push File.expand_path("../../lib", __FILE__)
require 'simple_asm'
include SimpleAsm

Simple.define_function(:be_255) do
  be 255
end

s = Simple.new do
  add r0, r1
  sub 0, 1
  ld 1, 0, 4
  st 0, 1, 8
  li 1, 10
  b 2, 11
  be_255
end

puts s.to_mif
