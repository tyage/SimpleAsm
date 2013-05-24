require 'simple_asm/inst_factory'
require 'simple_asm/inst_arithmetic'
require 'simple_asm/inst_load_store'
require 'simple_asm/inst_li_branch'

module SimpleAsm
  class Simple
    class << self
      REGISTER_SIZE = 8

      def define(name, symbols)
        define_method name do |*args|
          factory_args = Hash[*symbols.zip(args).flatten(1)]
          add_inst(InstFactory.create(name, factory_args))
        end
      end

      def define_with_inst(inst_class)
        inst_class.args_to_names_map.each do |args, names|
          names.each do |name|
            self.define(name, args)
          end
        end
      end

      def define_registers
        (0..REGISTER_SIZE-1).each do |i|
          name = ('r' + i.to_s).to_sym
          define_method name do
            return i
          end
        end
      end

      alias_method :use, :define_with_inst
    end

    use InstArithmetic
    use InstLoadStore
    use InstLiBranch

    define_registers

    def initialize(&block)
      @insts = []
      self.instance_eval(&block)
    end

    def to_s
      @insts.map{|inst| inst.to_s }.join("\n")
    end

    def to_mif
      # pending
    end

    private
    def add_inst(inst)
      @insts << inst
    end
  end
end
