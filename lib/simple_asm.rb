require 'simple_asm/inst_factory'
require 'simple_asm/inst_arithmetic'
require 'simple_asm/inst_load_store'
require 'simple_asm/inst_li_branch'

module SimpleAsm
  class Simple
    class << self
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

      alias_method :use, :define_with_inst
    end

    use InstArithmetic
    use InstLoadStore
    use InstLiBranch

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
