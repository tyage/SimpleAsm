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

  describe 'register' do
    before do
      @simple = Simple.new do
        add r0, r1
      end
    end

    it 'registerの値' do
      expect(@simple.r0).to eq 0
      expect(@simple.r1).to eq 1
      expect(@simple.r7).to eq 7
    end

    it 'registerのアドレスが展開される' do
      expect(@simple.to_s).to eq '1100100000000000'
    end
  end
end

