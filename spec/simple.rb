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

  describe 'arithmetic instructions' do
    it 'rd, rs形式' do
      s = Simple.new { add 0, 1 }
      expect(s.to_s).to eq '1100100000000000'
    end

    it 'rd, d形式' do
      s = Simple.new { sll 1, 4 }
      expect(s.to_s).to eq '1100000110000100'
    end
  end

  describe 'load store instructions' do
    it '正しく翻訳される' do
      s = Simple.new { ld 0, 1, 4 }
      expect(s.to_s).to eq '0000000100000100'
    end
  end

  describe 'li branch instructions' do
    it 'rb, d形式' do
      s = Simple.new { li 1, 4 }
      expect(s.to_s).to eq '1000000100000100'
    end

    it 'branch形式' do
      s = Simple.new { be 4 }
      expect(s.to_s).to eq '1011100000000100'
    end
  end
end

