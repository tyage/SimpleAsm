# encoding: utf-8
require 'simple_asm/inst'

# Jmp命令. preassembleでbranch命令に変換される
module SimpleAsm
  class InstJmp < Inst
    attr_reader :label

    NAME_TO_BRANCH_NAME = {
      :j => :b,
      :jmp => :b,
      :je => :be,
      :jlt => :blt,
      :jle => :ble,
      :jne => :bne
    }

    ARGS_TO_NAMES_MAP = {
      [:label] => [:j, :jmp, :je, :jlt, :jle, :jne]
    }.freeze

    class << self
      def names
        ARGS_TO_NAMES_MAP.values[0]
      end

      def args_to_names_map
        ARGS_TO_NAMES_MAP
      end
    end

    def initialize(name, args)
      throw "attribute label is needed" unless args[:label]
      @name = name
      @label = args[:label]
    end

    def to_branch_name
      NAME_TO_BRANCH_NAME[self.name]
    end

    def to_s
      self.class
    end
  end
end
