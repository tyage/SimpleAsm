require 'simple_asm/inst'

module SimpleAsm
  class InstZero < Inst
    class << self
      def names
        [:zero]
      end
    end

    def initialize(name, args)
    end

    def to_s
      '0000000000000000'
    end
  end
end
