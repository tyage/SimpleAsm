require "simple_asm/inst_arithmetic"
require "simple_asm/inst_load_store"
require "simple_asm/inst_li_branch"
require "simple_asm/inst_zero"

module SimpleAsm
  class InstFactory
    class << self
      INST_CLASSES = [InstArithmetic, InstLoadStore, InstLiBranch, InstZero]

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
