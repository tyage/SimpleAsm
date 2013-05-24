# encoding: utf-8
require 'simple_asm'
include SimpleAsm

describe Simple do
  describe 'to_s' do
    before do
      @simple = Simple.new do
        add 1, 0
        sub 0, 1
      end
    end

    it '各命令の長さは16' do
      @simple.to_s.split("\n").each do |s|
        expect(s.length).to eq 16
      end
    end
  end
end

