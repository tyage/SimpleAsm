require "simple_asm/inst_arithmetic"
require "simple_asm/inst_load_store"

module SimpleAsm
  class InstFactory
    class << self
      INST_CLASSES = [InstArithmetic, InstLoadStore]

      def create(name, args)
        INST_CLASSES.each do |klass|
          if klass.names.include?(name)
            return klass.new(name, args)
          end
        end
      end
    end
  end
end
