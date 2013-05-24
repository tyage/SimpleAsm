$:.push File.expand_path("../../lib", __FILE__)
require 'simple_asm'
include SimpleAsm
# アドレスは12ビット
# r0, r1
# length: 4
SWAP_LENGTH = 4

Simple.define_function(:swap) do |address_reg0, address_reg1|
  ld r0, address_reg0, 0
  ld r1, address_reg1, 0
  st address_reg0, r1, 0
  st address_reg1, r0, 0
end

Simple.define_function(:plus_one) do |register|
  add register, r4
end

# 0x400 ~ 0x7FFまでの数字ソート
# r0, r1: swap, size
# r2: i
# r3: j
# r4: 1
# r5: j_length
# r6, r7
s = Simple.new do
  i = r2
  j = r3
  size = r1

  # code
  li r4, 1
  # i = 1024
  li i, 1
  sll i, 10
  label :for_i
    # j = 1025
    li j, 1
    sll j, 10
    plus_one j

    label :for_j
      # r5 = size(2048) - i
      li size, 1
      sll size, 11
      sub r5, size

      # r7 = A[j-1]
      sub j, r4
      ld r7, j, 0

      # r6 = A[j]
      add j, r4
      ld r6, j, 0

      sub r6, r7
      blt SWAP_LENGTH - 1 + 2
      # r6 = j - 1
      mov r6, j
      sub r6, r4
      swap j, r6

    plus_one j
    sub r5, j
    jlt :for_j

  plus_one i
  # size == 1024
  li size, 1
  sll size, 10
  sub size, i
  jlt :for_i
end

puts s.to_mif(0x3ff)
