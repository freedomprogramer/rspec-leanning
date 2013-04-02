# rspec 第三步
 我不知道Test Double翻译成中文是什么，测试替身？
 Test Double就像是陈龙大哥电影里的替身，起到以假乱真的作用。在单元测试时，使用Test Double减少对被测对象的依赖耦合，使得测试更加单一，
同时，让测试案例执行的时间更短，运行更加稳定，同时能对SUT（System under test）内部的输入输出进行验证，让测试更加彻底深入。
但是，Test Double也不是万能的，Test Double不能被过度使用，因为实际交付的产品是使用实际对象的，过度使用Test Double会让测试变得越
来越脱离实际，当我们依赖的对象是一些不可控和开销比较大（如： 要连接数据库操作数据，连接网络请求数据或是依赖的对象或是API未被实现）我们
就可以考虑使用Test Double。

  rspec-mocks 是一个test-double系统框架, 在test-doubles和真实的对象上支持三个方法 stubs, fakes, message expections

## Test Doubles

  在rspec测试中模拟一个真实的对象时可以使用double(),stub(), mock()三个方法（我们可以在合适的语义下灵活使用它们），模拟的对象就拥有了
stubs, message expections这两个方法生成器.

    book = double("book") #这就模拟了一个book对象
    book.stub(:title).and_return("javascript")
    book.should_receive(:author).and_return("Dog")

## Method Stubs
  一个 stub 方法就是虚拟返回预先设定的一个值（求值、函数调用等等）， 可以用在test double 和真实对象上

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

## Message Expections
  message expection和stub很类似，都是期望一个方法调用然后返回一个期望值，它可以期望一个消息一次或者多次的期望。
但是message expection期望调用的方法必须在对象中被调用不然即使对象返回值和message expection的返回值相同也会报错。  

    class Statement do
      def initialize(customer)
        @customer = customer
      end
      
      def generate
        "Statement for #{@customer.name}"
      end
    end

    describe Statement do
      it "logs a message on generate()" do
        customer = stub('customer')
        customer.should_receive(:name).and_return('lee')
        statement = Statement.new(customer)
        statement.generate.should =~ /^Statement for lee/
      end
    end
    
    # 这里我们测试会通过因为在generate方法中调用了customer的name方法。
    # 若不调用直接在里面写"Statement for lee",那么将会失败。

## Test-Specific Extension
  我们可以通过给真是存在的对象使用stub和message expection以此来扩展对象，当对象调用自己部分方法代价过高时
它就可以通过stub 和 message expection 来模拟自己的方法行为。

    describe WidgetsController do
      describe "PUT update with valid attributes"
       it "finds the widget"
         widget = Widget.new()
         widget.stub(:update_attributes).and_return(true)
         Widget.should_receive(:find).with("37").and_return(widget)
         put :update, :id => 37
       end

       it "updates the widget's attributes" do
         widget = Widget.new()
         Widget.stub(:find).and_return(widget)
         widget.should_receive(:update_attributes).and_return(true)
         put :update, :id => 37
       end
      end
    end


## 术语
Mock Objects 和 Test Stubs
  Test Stub(Stub)是一个仅仅支持method stubs的 Test Double
Mock Object(Mock)是一个仅仅支持message expections的 Test Double

  从单元测试(Xunit)里面集成出来很多的术语(fakes spies), 在rspec不这样讨论。
我们大多数时候讨论都是方法级别的， method stubd 和 message expections。
并且它们逻辑上都是一种对象test double。

    # Person 收到任何find消息，都会返回一个person
    person = double("person")
    Person.stub(:find) { person }

    # Person 将会受到一个find消息， 会返回一个person， 在example结束的时候如果没有将会失败。也就是说
    # 采用此方法必须进行调用在后面。
    person = double("person")
    Person.should_receive(:find) { person }

我们可以在测试系统任意对象上使用stub和should_receive方法， 包括类对象。

**注意： 仔细理解两者之间的差别**



## More stub

### 连续返回值
  通过调用and_return来返回一串连续的值


    die.stub(:roll).and_return(1,2,3)
    die.roll # => 1
    die.roll # => 2
    die.roll # => 3
    die.roll # => 3
    die.roll # => 3
    # 返回一个数组
    team.stub(:players).and_return([stub(:name => "David")])

### 链式调用

    # 当我们通过一系列条件来过滤出我们需要的结果，

    recent = double()
    published = double()
    article = double()
    Article.stub(:recent).and_return(recent)
    recent.stub(:published).and_return(:published)
    published.stub(:author_by).and_return(article)
    
    链式写法：
    article = double()
    Article.stub_chain(:recent, :published, :author_by).and_return(article)
    
### 条件判断
  当我们想要根据不同输入值返回不同值，我们可以通过block来返回不同状态，这样我们的状态就可以被多次重用
  
    ages = double("ages")
    ages.stub(:age_for) do |what|
      if what == 'drinking'
        21
      elsif what == 'coting'
        18
      end  
    end
    

## More message Exception

### 设定期望参数
 
    double.should_receive(:msg).with(*args)
    double.should_not_receive(:msg).with(*args)

    # 设定期望的多个参数
    double.should_receive(:msg).with("A", 1, 3)
    double.should_receive(:msg).with("B", 2, 4)

    # 在调用时候如果参数跟期望的不同会报错

### 参数匹配器
  默认真实收到的参数实际上是在和with的参数做 ==（Rspec Matcher） 运算。
如果你不想使用Rspec Matcher和下面提供的matcher， 可以实现自己的matcher

    # 表示不接收参数
    double.should_receive(:msg).with(no_args())
  
    # 表示可以接收任何参数
    double.should_receive(:msg).with(any_args())
  
    #2nd argument can be any kind of Numeric
    double.should_receive(:msg).with(1, instance_of(Numeric), "b") 

    #2nd argument can be true or false
    double.should_receive(:msg).with(1, boolean(), "b") 
  
    # 假如期望一个hash参数, 我们可以指定这个hash值是什么
    mock_account.should_receive(:add_payment_accounts).
      with(hash_including('name' => 'jackie', 'age' => 18))
    
    # 我们能够指定哪些值不在hash中
    mock_account.should_receive(:add_payment_accounts).
      with(hash_not_including('name' => 'jackie', 'age' => 18))

    #2nd argument can be any String matching the submitted Regexp
    double.should_receive(:msg).with(1, /abc/, "b") 

    #2nd argument can be anything at all
    double.should_receive(:msg).with(1, anything(), "b") 

    #2nd argument can be object that responds to #abs and #div
    double.should_receive(:msg).with(1, duck_type(:abs, :div), "b")

### 设定方法调用次数

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
    
    # 设定方法不被调用
    double.should_not_receive(:open_connection)
    等于
    double.should_receive(:open_connection).exactly(0).times

### 有序接受消息

    double.should_receive(:msg).ordered
    double.should_receive(:other_msg).ordered
    # 如果收到的消息不是有序， 那么测试(example)将会是失败

    # 设定同样的消息， 不同的参数
    double.should_receive(:msg).with("A", 1, 3).ordered
    double.should_receive(:msg).with("B", 2, 4).ordered

### 精确响应

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

### 更加灵活的处理

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

### 采用原始的实现

    Person.should_receive(:find).and_call_original
    Person.find # => executes the original find method and returns the result

### 结合一连串的期待

    double.should_receive(:<<).with("illegal value").once.and_raise(ArgumentError)


## before(:each) before(:all)
  Stubs 不支持before(:all), 因为所有的stubs和mocks被清除都是在每个example之后。
  因此在第一example中stubs是工作， 在后面就不一定能够成功了。
  所以， 全不是使用 before(:each)， 不用考虑这点性能问题， 这样尽量避免出错。
