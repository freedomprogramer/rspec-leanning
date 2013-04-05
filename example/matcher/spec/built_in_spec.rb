# -*- coding: utf-8 -*-
require 'helper_spec'

class Calculator
  class << self
    def divisor(num1, num2)
      begin
        num1 / num2
      rescue ZeroDivisionError
        raise ZeroDivisionError, "dividen can't be 0"
      end
    end
  end
end

class Newspaper
  class << self
    def heading
      "I am so happy to programming, I think programing is very cool, I love so much!!!"
    end
  end
end

describe Calculator do
  context "num2 equal to 0" do
    it "should raise a error" do
      # expect在做expect errors和expect throws时
      # 后面是跟的{}， 其余时间后面跟的是() 
      expect{Calculator.divisor(1, 0)}.to raise_error(ZeroDivisionError)
    end
  end

  context "num2 not equal to 0" do
    it "should be == when expect and result be_close" do
      expect(Calculator.divisor(1.0, 3)).to be_close(0.3, 0.04)
    end
  end
end

describe Newspaper do
  describe "#heading" do
    it "output a programmer' voice" do
      expect(Newspaper.heading).to match(/programing is very cool/)
    end
  end
end

