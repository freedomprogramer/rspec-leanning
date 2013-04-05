require 'helper_spec'

class Counter
  class << self
    def increment
      @count ||= 0
      @count += 1
    end
    
    def count
      @count ||= 0
    end
  end
end

describe Counter, "#increment" do
  it "should not increment the count by 2" do
    expect{Counter.increment}.to_not change{Counter.count}.from(0).to(2)
  end

  it "should not increment the count by 1" do
    expect{Counter.increment}.to_not change{Counter.count}.by(2)
  end
end
