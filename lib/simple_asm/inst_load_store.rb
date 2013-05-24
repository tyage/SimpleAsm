require 'simple_asm/inst'

module SimpleAsm
  class InstLoadStore < Inst
    attr_reader :op1, :ra, :rb, :d

    NAME_TO_OP = {
      :ld => 0b00,
      :st => 0b01
    }.freeze

    ARGS_TO_NAMES_MAP = {
      [:ra, :rb, :d] => [:ld, :st]
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
      @ra = args[:ra]
      @rb = args[:rb]
      @d = args[:d]
      @op1 = name_to_op(name)
    end

    def to_s
      sprintf("%02b%03b%03b%08b", @op1, @ra, @rb, @d)
    end

    private
    def name_to_op(name)
      NAME_TO_OP[name]
    end
  end
end
