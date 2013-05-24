require 'simple_asm/inst'

module SimpleAsm
  class InstLiBranch < Inst
    attr_reader :op2, :rb, :d

    LI_B_CODE = 0b10

    NAME_TO_OP = {
      :li => 0b000,
      :b => 0b100,
      :be => 0b111,
      :blt => 0b111,
      :ble => 0b111,
      :bne => 0b111
    }.freeze

    NAME_TO_COND = {
      :be => 0b000,
      :blt => 0b001,
      :ble => 0b010,
      :bne => 0b011
    }.freeze

    ARGS_TO_NAMES_MAP = {
      [:rb, :d] => [:li, :b],
      [:d] => [:be, :blt, :ble, :bne]
    }.freeze

    class << self
      def names
        NAME_TO_OP.keys
      end

      def args_to_names_map
        ARGS_TO_NAMES_MAP
      end
    end

    def initialize(name, args)
      @d = args[:d]
      @op2 = name_to_op(name)

      # branch cond
      @rb = ARGS_TO_NAMES_MAP[[:d]].include?(name) ? NAME_TO_COND[name] : args[:rb]
    end

    def to_s
      sprintf("%02b%03b%03b%08b", LI_B_CODE, @op2, @rb, @d)
    end

    private
    def name_to_op(name)
      NAME_TO_OP[name]
    end
  end
end
