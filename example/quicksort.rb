$:.push File.expand_path("../../lib", __FILE__)
require 'simple_asm'
include SimpleAsm

THRESHOLD = 10
LEFT_STACK_BASE = 0x300  # 1100000000
RIGHT_STACK_BASE = 0x380 # 1110000000

Simple.define_function(:load_left_stack_base) do |register|
  li register, 0b11
  sll register, 8
end

Simple.define_function(:load_right_stack_base) do |register|
  li register, 0b111
  sll register, 7
end

Simple.define_function(:addi) do |register, i|
  li r7, i
  add register, r7
end

Simple.define_function(:subi) do |register, i|
  li r7, i
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
  sll i, 10

  label :for_inssort_1
    # i < n;
    cmp n, i
    jle :end_for_inssort_1

    # x = a[i]
    ld x, i, 0

    # j = i - 1;
    mov j, i
    subi j, 1
    label :for_inssort_2
      # j >= 0;
      li r7, 0
      cmp r7, j
      jlt :end_for_inssort_2
      # a[j] > x;
      ld r7, j, 0
      cmp r7, x
      jle :end_for_inssort_2

      # a[j+1] = a[j]
      mov r6, j
      addi r6, 1

      ld r7, j, 0

      st r7, r6, 0

      # j--;
      subi j, 1
      jmp :for_inssort_2
    label :end_for_inssort_2
    addi i, 1

    mov r6, j
    addi r6, 1

    st x, r6, 0

    # i++;
    addi i, 1
    jmp :for_inssort_1
  label :end_for_inssort_1

end

# 0x400 ~ 0x7FFまでの数字ソート
# r0, r1: left, right
# r2 : p
s = Simple.new do
  left = r0
  right = r1
  p = r2

  # left = 0x400
  li left, 1
  sll left, 10

  # right = 0x7FF
  li right, 0b11111111
  sll right, 3
  li r7, 0b111
  add right, r7

  # p = 0
  li p, 0

  # for( ; ; )
  label :for
    # if (right - left <= THRESHOLD)
    li r7, THRESHOLD
    add r7, left
    cmp r7, right
    jlt :threshold
      # if (p == 0) break;
      li r7, 0
      cmp p, r7
      je :end_for

      # p--;
      subi p, 1

      # left = leftstack[p]
      load_left_stack_base r7
      add r7, p
      mov left, r7

      # right = rightstack[p]
      load_right_stack_base r7
      add r7, p
      mov right, r7
    label :threshold

    # x = a[(left + right) / 2]
    x = r4
    counter = r5
    mov r6, left
    add r6, right
    li counter, 0
    label :divide_2
      li r7, 2
      sub r6, r7

      li r7, 0
      cmp r6, r7
      jlt :end_divide_2

      addi counter, 1
      jmp :divide_2
    label :end_divide_2

    ld x, counter, 0

    # i = left; j = right
    i = r6
    j = r5
    mov i, left
    mov j, right

    # i, j = r6, r5
    label :for2
      # while(a[i] < x) i++;
      label :while_i
        a_i = r7
        ld a_i, i, 0
        cmp x, a_i
        jle :end_while_i
        li r7, 1
        add i, r7
        jmp :while_i
      label :end_while_i

      # while(x < a[j]) j--;
      label :while_j
        a_j = r7
        ld a_j, j, 0
        cmp a_j, x
        jle :end_while_j
        li r7, 1
        sub j, r7
      label :end_while_j

      # if (i >= j) break;
      mov r7, i
      sub r7, j
      jlt :end_if_i_j
        jmp :end_for
      label :end_if_i_j

      # t = a[i]; a[i] = a[j]; a[j] = t;
      a_i = r7
      a_j = r4
      ld a_i, i, 0
      ld a_j, j, 0
      st a_j, i, 0
      st a_i, j, 0

      # i++; j--;
      addi i, 1
      subi j, 1
    label :end_for2

    mov r7, i
    sub r7, left
    mov r4, right
    sub r4, j
    cmp r7, r4
    jle :else_1
    # if (i - left > right - j) {
      # if (i - left > THRESHOLD)
      mov r7, i
      sub r7, left
      li r4, THRESHOLD
      cmp r7, r4
      jle :end_if_1_1
        # leftstack[p] = left;
        load_left_stack_base r7
        add r7, p
        st left, r7, 0

        # rightstack[p] = i - 1;
        load_right_stack_base r7
        add r7, p
        mov r4, i
        li r3, 1
        sub r4, r3
        st r3, r7, 0

        # p++;
        addi p, 1
      label :end_if_1_1
      # left = j + 1;
      mov r7, j
      li r4, 1
      add r7, r4
      mov left, r7

      jmp :end_if_1
    # } else {
    label :else_1
      # if (right - j > THRESHOLD)
      mov r7, i
      sub r7, left
      li r4, THRESHOLD
      cmp r7, r4
      jle :end_if_1_2
        # leftstack[p] = j + 1;
        load_left_stack_base r7
        add r7, p
        mov r4, j
        li r3, 1
        add r4, r3
        st r4, r7, 0

        # rightstack[p] = right;
        load_right_stack_base r7
        add r7, p
        st right, r7, 0

        # p++;
        addi p, 1
      label :end_if_1_2
      # right = i - 1;
      mov r7, i
      li r4, 1
      sub r7, r4
      mov right, r7
    label :end_if_1

    jmp :for
  label :end_for

  inssort
end

puts s.to_mif
