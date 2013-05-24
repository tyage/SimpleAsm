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
    }.freeze

    ARGS_TO_NAMES_MAP = {
      [:rd, :rs] => [:add, :sub, :and, :or, :xor, :cmp, :mov],
      [:rd, :s] => [:sll, :slr, :srl, :sra, :in, :out],
      [:d]    => [:hlt]
    }.freeze

    PREFIX_CODE = 0b11

    class << self
      def names
        NAME_TO_OP.keys
      end

      def args_to_names_map
        ARGS_TO_NAMES_MAP
      end
    end

    def initialize(name, args)
      @rs = args[:rs] || 0
      @rd = args[:rd] || 0
      @d = args[:d] || 0
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
