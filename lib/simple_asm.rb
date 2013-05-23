require 'simple_asm/inst_factory'
require 'simple_asm/inst'
require 'simple_asm/inst_arithmetic'

module SimpleAsm
  class Simple
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

    InstArithmetic.names[:rd_rs].each do |name|
      define_method name do |rd, rs|
        add_inst(InstFactory.create(name, { :rs => rs, :rd => rd }))
      end
    end

    InstArithmetic.names[:rd_d].each do |name|
      define_method name do |rd, d|
        add_inst(InstFactory.create(name, { :rd => rd, :d => d }))
      end
    end

    InstArithmetic.names[:d].each do |name|
      define_method name do |d|
        add_inst(InstFactory.create(name, { :d => d }))
      end
    end

    private
    def add_inst(inst)
      @insts << inst
    end
  end
end
