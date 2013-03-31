class User
  def initialize(name, password)
    @name = name
    @password = password
  end
end

class Stack
end

##  You: Describe a account
##  Somebody else: It should have a balance of zero

class Money
  def initialize(num, type)
    @num = num
    @type = type
  end

  def total_money
    return @num
  end
end

class Account
  def balance
    return Money.new(0, :USD).total_money
  end
end

describe "A new Account" do
   it "should have a balance of 0" do
     account = Account.new
     account.balance.should == Money.new(0, :USD).total_money
   end
end


## what's the example
## what's the example group
## use: irb console
describe Array do

end

describe Array do
  it "should include a method of :new" do
    Array.should respond_to :new
  end
end

## It's different from 'describe' and context
## alias :describe , :context
describe User do
  describe "with no roles assigned" do
    it "is not allowed to view protected content" do

    end
  end
end

describe User do
  context "with no roles assigned" do
    it "is not allowed to view protected content" do

    end
  end
end

## pending example


## hooks: before, after, around
describe Stack do
  context "when empty" do
    before(:each) do
      @stack = Stack.new
    end
  end

  context "when almost empty (with one element)" do
    before(:each) do
      @stack = Stack.new
      @stack.push 1
    end
  end

  context "when almost full (with one element less than capacity)" do
    before(:each) do
      @stack = Stack.new
      (1..9).each { |n| @stack.push n }
    end
  end

  context "when full" do
    before(:each) do
      @stack = Stack.new
      (1..10).each { |n| @stack.push n }
    end
  end
end

## help methods
module UserExampleHelpers
  def create_valid_user
    User.new(:email => 'email@example.com', :password => 'shhhhh')
  end

  def create_invalid_user
    User.new(:password => 'shhhhh')
  end
end

describe User do
  include UserExampleHelpers

  it "does something when it is valid" do
    user = create_valid_user
  end

  it "does something when it is not valid" do
    user = create_invalid_user
  end
end

Rspec.configure do |config|
  config.include(UserExampleHelpers)
end

## stub_method
class Statement
  def initialize(customer)
    @customer = customer
  end

  def generate
    "Statement for #{@customer.name}"
    # "Statement for Aslak"
  end
end

describe Statement do
  it "uses the customer's name in the header" do
    customer = double('customer')
    customer.stub(:name).and_return('Aslak')
    statement = Statement.new(customer)
    statement.generate.should =~ /^Statement for Aslak/
  end
end


## message expectation
describe Statement do
  it "uses the customer's name in the header" do
    customer = double('customer')
    customer.should_receive(:name).and_return('Aslak')
    statement = Statement.new(customer)
    statement.generate.should =~ /^Statement for Aslak/
  end
end

describe Statement do
  it "uses the customer's name in the header" do
    #customer = mock('customer')
    customer = stub('customer')
    customer.stub(:name).and_return('Aslak')
    statement = Statement.new(customer)
    statement.generate.should =~ /^Statement for Aslak/
  end
end

describe Statement do
  it "uses the customer's name in the header" do
    customer = stub('customer', name: 'Aslak')
    statement = Statement.new(customer)
    statement.generate.should =~ /^Statement for Aslak/
  end
end

describe Statement do
  it "uses the customer's name in the header" do
    customer = mock('customer')
    customer.should_receive(:name).and_return('Aslak')
    statement = Statement.new(customer)
    statement.generate.should =~ /^Statement for Aslak/
  end
end

