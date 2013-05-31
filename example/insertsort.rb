$:.push File.expand_path("../../lib", __FILE__)
require 'simple_asm'
include SimpleAsm

Simple.define_function(:load_array_base) do |register|
  li register, 1
  sll register, 10
  addi register, 1
end

Simple.define_function(:load_array_pointer) do |register, p|
  load_array_base register
  add register, p
end

Simple.define_function(:plus_one) do |register|
  addi register, 1
end

Simple.define_function(:minus_one) do |register|
  li r7, 1
  sub register, r7
end

Simple.define_function(:inssort) do
  i = r0
  j = r1
  x = r2
  n = r3

  li n, 1
  sll n, 10

  li i, 1

  label :for_inssort_1
    # i < n;
    cmp n, i
    jle :end_for_inssort_1

    # x = a[i]
    load_array_pointer r7, i
    ld x, r7, 0

    # j = i - 1;
    mov j, i
    minus_one j
    label :for_inssort_2
      # j >= 0;
      li r7, 0
      cmp j, r7
      jlt :end_for_inssort_2 # jmp if j < 0

      # a[j] > x;
      load_array_pointer r7, j
      ld r6, r7, 0
      cmp r6, x

      jle :end_for_inssort_2 # jmp if a[j] - x <= 0

      # a[j+1] = a[j]
      load_array_pointer r7, j
      load_array_pointer r6, j
      plus_one r6

      ld r5, r7, 0
      st r5, r6, 0

      # j--;
      minus_one j
      jmp :for_inssort_2
    label :end_for_inssort_2

    # a[j+1] = x;
    load_array_pointer r6, j
    plus_one r6

    st x, r6, 0

    # i++;
    plus_one i
    jmp :for_inssort_1
  label :end_for_inssort_1
end

s = Simple.new do
  inssort
  hlt
end


puts s.to_mif
