require "simple_asm/inst"

module SimpleAsm
  class InstArithmetic < Inst
    attr_reader :rs, :rd, :op3, :d

    NAME_TO_OP = {
      :add => 0b0000,
      :sub => 0b0001,
      :and => 0b0010,
      :or => 0b0011,
      :xor => 0b0100,
      :cmp => 0b0101,
      :mov => 0b0110,
      :sll => 0b1000,
      :slr => 0b1001,
      :srl => 0b1010,
      :sra => 0b1011,
      :in => 0b1100,
      :out => 0b1101,
      :hlt => 0b1111,
    }

    NAMES = {
      :rd_rs => [:add, :sub, :and, :or, :xor, :cmp, :mov],
      :rd_d => [:sll, :slr, :srl, :sra, :in, :out],
      :d    => [:hlt]
    }

    PREFIX_CODE = 0b11

    class << self
      def names
        NAMES
      end
    end

    def initialize(name, rs, rd, d)
      @rs = rs || 0
      @rd = rd || 0
      @d = d || 0
      @op3 = name_to_op(name)
    end

    def to_s
      sprintf("%02b%03b%03b%04b%04b", PREFIX_CODE, @rs, @rd, @op3, @d)
    end

    def to_i
      self.to_s.to_i(2)
    end

    private
    def name_to_op(name)
      NAME_TO_OP[name]
    end
  end
end