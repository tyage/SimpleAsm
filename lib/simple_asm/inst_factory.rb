require "simple_asm/inst_arithmetic"

module SimpleAsm
  class InstFactory
    class << self
      def create(name, args)
        case name
        when *InstArithmetic.names
          create_arithmetic(name, args)
        end
      end

      private
      def create_arithmetic(name, args)
        InstArithmetic.new(name, args[:rs], args[:rd], args[:d])
      end
    end
  end
end
