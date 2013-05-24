require "simple_asm/inst_arithmetic"
require "simple_asm/inst_load_store"
require "simple_asm/inst_li_branch"
require "simple_asm/inst_zero"
require "simple_asm/inst_jmp"

module SimpleAsm
  class InstFactory
    class << self
      @@inst_classes = []

      def create(name, args)
        @@inst_classes.each do |klass|
          if klass.names.include?(name)
            return klass.new(name, args)
          end
        end
      end

      def register(inst_class)
        @@inst_classes << inst_class
      end
    end
  end
end
