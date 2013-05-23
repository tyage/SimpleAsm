module SimpleAsm
  class Inst
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def to_s
      raise 'must implement to_s'
    end

    def to_i
      raise 'must implement to_i'
    end
  end
end
