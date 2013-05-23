$:.push File.expand_path("../../lib", __FILE__)
require 'simple_asm'

s = SimpleAsm::Simple.new do |simple|
  add 1, 0
  sub 0, 1
end

puts s.to_s
