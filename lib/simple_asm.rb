require 'simple_asm/inst_factory'
require 'simple_asm/inst_arithmetic'
require 'simple_asm/inst_load_store'
require 'simple_asm/inst_li_branch'
require 'simple_asm/inst_zero'
require 'simple_asm/inst_jmp'

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

      def use(inst_class)
        InstFactory.register(inst_class)

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

      def define_label
        define_method(:label) do |name|
          @labels[name] = @insts.length
        end
      end

      def define_exts
        define_registers
        define_label
        self.define(:zero, [])
        InstFactory.register(InstZero)
      end


      def define_function(name, &block)
        define_method(name, &block)
      end
    end

    use InstArithmetic
    use InstLoadStore
    use InstLiBranch
    use InstJmp

    define_exts

    def initialize(&block)
      @insts = []
      @labels = {}
      self.instance_eval(&block) if block
    end

    def to_s
      preassemble
      @insts.map{|inst| inst.to_s }.join("\n")
    end

    def to_a
      preassemble
      @insts
    end

    def to_mif(depth=256)
      preassemble
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

    def preassemble
      foo =  @insts.map.with_index do |inst, pc|
        if inst.is_a? InstJmp
          label_line = @labels[inst.label]
          throw "label :#{inst.label.to_s} is undefined" unless label_line

          branch_name = inst.to_branch_name

          InstFactory.create(branch_name, { :rb => 0,  :d => label_line - (pc + 1) })
        else
          inst
        end
      end
      @insts = foo
    end
  end
end
