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
  it "should increment the count" do
    expect{Counter.increment}.to change{Counter.count}.from(0).to(1)
  end

  it "should increment the count by 2" do
    expect{Counter.increment}.to change{Counter.count}.by(1)
  end
end
