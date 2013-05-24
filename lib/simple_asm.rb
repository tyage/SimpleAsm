require 'simple_asm/inst_factory'
require 'simple_asm/inst_arithmetic'
require 'simple_asm/inst_load_store'
require 'simple_asm/inst_li_branch'
require 'simple_asm/inst_zero'

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

      def define_exts
        define_registers
        self.define(:zero, [])
      end

      alias_method :use, :define_with_inst
    end

    use InstArithmetic
    use InstLoadStore
    use InstLiBranch

    define_exts

    def initialize(&block)
      @insts = []
      self.instance_eval(&block) if block
    end

    def to_s
      @insts.map{|inst| inst.to_s }.join("\n")
    end

    def to_a
      @insts
    end

    def to_mif(depth=256)
      mif_text = <<-MIF
WIDTH=16;
DEPTH=#{depth};

ADDRESS_RADIX=HEX;
DATA_RADIX=BIN;

CONTENT BEGIN
      MIF

      @insts.each_with_index do |inst, index|
        mif_text << "\t#{'%03X' % index}  :   #{inst.to_s};\n"
      end

      mif_text << "\t[#{'%03X' % @insts.length}..#{'%03X' % depth}]  :   #{'%016b' % 0};\n"

      mif_text << "END;\n"
    end

    private
    def add_inst(inst)
      @insts << inst
    end
  end
end
