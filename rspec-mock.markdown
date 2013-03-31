# rspec 第三步

  我不知道Test Double翻译成中文是什么，测试替身？
Test Double就像是陈龙大哥电影里的替身，起到以假乱真的作用。在单元测试时，使用Test Double减少对被测对象的依赖，使得测试更加单一，
同时，让测试案例执行的时间更短，运行更加稳定，同时能对SUT（System under test）内部的输入输出进行验证，让测试更加彻底深入。
但是，Test Double也不是万能的，Test Double不能被过度使用，因为实际交付的产品是使用实际对象的，过度使用Test Double会让测试变得越
来越脱离实际。

  rspec-mocks 是一个test-double系统框架, 在test-doubles和真实的对象上支持三个方法 stubs, fakes, message expections

## Test Doubles

  test double在rspec测试中就是一个真实的对象， 它支持 stubs, message expections 方法.

eg:
  book = double("book") #这就模拟了一个book对象

## Method Stubs
  一个 stub 方法就是虚拟返回预先设定的一个值（求值、函数调用等等）， 可以用在test double 和真实对象上

eg:
  book.stub(:title) { "The RSpec Book" }
  book.stub(:title => "The RSpec Book")
  book.stub(:title).and_return("The RSpec Book")
  # 给book对象send一个:title消息 返回"The RSpec Book"
  # 这里的book可以是真实的对象， 也可以使是test-double

  # 提供给test-double的一种简写方式
  book = double("book", :title => "The RSpec Book")
  double(:foo => 'bar')

  # 给个方法传递一系列连续的test-double返回一个值时候这样写
  order.calculate_total_price(stub(:price => 1.99),stub(:price => 2.99))

## 连续返回值
  通过调用and_return来返回一串连续的值

eg:
  die.stub(:roll).and_return(1,2,3)
  die.roll # => 1
  die.roll # => 2
  die.roll # => 3
  die.roll # => 3
  die.roll # => 3
  # 返回一个数组
  team.stub(:players).and_return([stub(:name => "David")])

## Message Expections
  一个message expection是在一个example中一个test-double接受到一个消息一次或者多次的期望。如果接受
  到消息， 那么成功。没有接收到消息则会失败。

eg:
  validator = double("validator")
  validator.should_receive(:validate).with("02134")
  zipcode = Zipcode.new("02134", validator)
  zipcode.valid?

## 术语
Mock Objects 和 Test Stubs
Test Stub(Stub)是一个仅仅支持method stubs的 Test Double
Mock Object(Mock)是一个仅仅支持message expections的 Test Double

从单元测试(Xunit)里面集成出来很多的术语(fakes spies), 在rspec不这样讨论。
我们大多数时候讨论都是方法级别的， method stubd 和 message expections。
并且它们逻辑上都是一种对象test double。


eg:
  # Person 收到任何find消息，都会返回一个person
  person = double("person")
  Person.stub(:find) { person }

  # Person 将会受到一个find消息， 会返回一个person， 在example结束的时候如果没有将会失败。也就是说
  # 采用此方法必须进行调用在后面。
  person = double("person")
  Person.should_receive(:find) { person }

我们可以在测试系统任意对象上使用stub和should_receive方法， 包括类对象。

  注意： 仔细理解两者之间的差别

## 设定期望参数
  double.should_receive(:msg).with(*args)
  double.should_not_receive(:msg).with(*args)

  # 设定期望的多个参数
  double.should_receive(:msg).with("A", 1, 3)
  double.should_receive(:msg).with("B", 2, 4)


## 参数匹配器
  默认真实收到的参数实际上是在和with的参数做 ==（Rspec Matcher） 运算。
  如果你不想使用Rspec Matcher和下面提供的matcher， 可以实现自己的matcher

  # 原生为with提供的关键字参数
  double.should_receive(:msg).with(no_args())
  double.should_receive(:msg).with(any_args())
  
  #2nd argument can be any kind of Numeric
  double.should_receive(:msg).with(1, kind_of(Numeric), "b") 

  #2nd argument can be true or false
  double.should_receive(:msg).with(1, boolean(), "b") 

  #2nd argument can be any String matching the submitted Regexp
  double.should_receive(:msg).with(1, /abc/, "b") 

  #2nd argument can be anything at all
  double.should_receive(:msg).with(1, anything(), "b") 

  #2nd argument can be object that responds to #abs and #div
  double.should_receive(:msg).with(1, duck_type(:abs, :div), "b")


## 接受消息统计
  double.should_receive(:msg).once
  double.should_receive(:msg).twice
  double.should_receive(:msg).exactly(n).times
  double.should_receive(:msg).at_least(:once)
  double.should_receive(:msg).at_least(:twice)
  double.should_receive(:msg).at_least(n).times
  double.should_receive(:msg).at_most(:once)
  double.should_receive(:msg).at_most(:twice)
  double.should_receive(:msg).at_most(n).times
  double.should_receive(:msg).any_number_of_times

## 有序接受消息
  double.should_receive(:msg).ordered
  double.should_receive(:other_msg).ordered
  # 如果收到的消息不是有序， 那么测试(example)将会是失败

  # 设定同样的消息， 不同的参数
  double.should_receive(:msg).with("A", 1, 3).ordered
  double.should_receive(:msg).with("B", 2, 4).ordered


## 精确响应

  double.should_receive(:msg) { value }

  # 当受收到对应的消息的时候， 将会执行后面block， 返回block执行的值
  double.should_receive(:msg).and_return(value)

  # 这个标识第一次调用返回value1,第二次返回value2,第三次返回value3...
  double.should_receive(:msg).exactly(3).times.and_return(value1, value2, value3)

  # 这里的error可以是对像或是类
  # if it is a class, it must be instantiable with no args
  double.should_receive(:msg).and_raise(error)

  double.should_receive(:msg).and_throw(:msg)
  double.should_receive(:msg).and_yield(values,to,yield)
  double.should_receive(:msg).and_yield(values,to,yield).and_yield(some,other,values,this,time)
  # for methods that yield to a block multiple times

  double.stub(:msg).and_return(value)
  double.stub(:msg).and_return(value1, value2, value3)
  double.stub(:msg).and_raise(error)
  double.stub(:msg).and_throw(:msg)
  double.stub(:msg).and_yield(values,to,yield)
  double.stub(:msg).and_yield(values,to,yield).and_yield(some,other,values,this,time)

## 更加灵活的处理

  double.should_receive(:msg) do |arg|
    arg.size.should eq(7)
  end

  double.should_receive(:msg) do |&arg|
    begin
      arg.call
    ensure
      # cleanup
    end
  end

## 采用原始的实现

  Person.should_receive(:find).and_call_original
  Person.find # => executes the original find method and returns the result

## 结合一连串的期待

  double.should_receive(:<<).with("illegal value").once.and_raise(ArgumentError)


## before(:each) before(:all)
  Stubs 不支持before(:all), 因为所有的stubs和mocks被清除都是在每个example之后。
  因此在第一example中stubs是工作， 在后面就不一定能够成功了。
  所以， 全不是使用 before(:each)， 不用考虑这点性能问题， 这样尽量避免出错。
