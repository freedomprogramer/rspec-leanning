# Rspec 第二步（rspec expectations)
  RSpec::Expectations 让你能够在测试example中表达你所期望得到的对象, Rspec应用非技术的词汇表达一些
行为,非技术人员也能够理解我们所描述的业务。  

## 基本用法
  在Rspec中我们设置一个期望应该发生而不是像像assert中的那样描述的说要发生。Rspec给每个mathch object都动态添加了should, should\_not
方法来表达一种期望，当match object产生的值和后面的期望匹配那么测试通过，如果失败那么将会引发一个错误。

    describe Order do
      it "sums the prices of the items in its line items" do
        order = Order.new
        order.add_entry(LineItem.new(:item => Item.new(
          :price => Money.new(1.11, :USD)
        )))
        order.add_entry(LineItem.new(:item => Item.new(
          :price => Money.new(2.22, :USD),
          :quantity => 2
        )))
        expect(order.total).to eq(Money.new(5.55, :USD))
      end
    end

    结果：
    If order.total == Money.new(5.55, :USD) then the example passes, If not

    expected: #<Money @value=5.55 @currency=:USD>
       got: #<Money @value=1.11 @currency=:USD>

## Buit-in matchers

  1. 在Rspec中我们做值匹配时候可以选择**==** 或是 **eql**
  
        (3 * 5).should == 15
        or
        (3 * 5).should eql(15)
        
  2. 做对象匹配时候我们可以选**===** 或是 **equal**
  
        person = Person.create!(:name => "Lee")
        Person.find_by_name("Lee").should equal(person)
        or
        Person.find_by_name("Lee").should ===(person)
  
  3. 处理浮点书匹配我们可以使用 **be_close(expect, precision)**
  
        result.should be_close(5.25, 0.005) #这个表示result的值在5.25 ~ 5.255之间匹配
        
  4. 处理多行文本匹配我们可以进行正则匹配 **=~ /some expect text/* 或者 **match(/some expect text/)**     
  
        result.should match(/***/)
        result.should =~ /***/
        
  5. 当处理一个行为的发生对一个状态的改变通过**by(), to(), from()** 进行描述
  
        expect{
          User.create!(:role => "admin")
        }.to change{ User.admins.count }.by(1)
        
        or
        
        expect{
          User.create!(:role => "admin")
        }.to change{ User.admins.count }.to(1)
        
        or
        
        expect{
          User.create!(:role => "admin")
        }.to change{ User.admins.count }.from(0).to(1)
        
        这个不只是应用于Rails中：
        expect{
          seller.accept Offer.new(250000)
        }.to change{ agent.commision }.by(7500)
        
  6. 测试程序异常处理, 我们可以使用**raise\_error**: 这个方法可以接受0~2个参数,分别为异常类型, 异常消息(string 或是 正则),       
     * 不传递参数, 默认只要捕获任何Exception就通过.
       
          expect{ do_something_risky }.to raise_error
          
     * 传递一个参数: 可以是异常的messages或是异常类型
     
          expect{
            account.withdraw 75, :dollar
          }.to raise_error("attempt to get 75$, but account only left 50$")
          
          expect{
            account.withdraw 75, :dollar
          }.to raise_error(InsufficientFundsError)     
          
          
     * 传递两个参数: 一个异常类型, 一个异常messages
      
  7. 当处理throw/catch时候, 我们可以使用**throw\_symbol**, 这个方法接受参数和raise\_error一样   
  
  **补充:**
  
  当我们做相反匹配的时候我们不能使用!=等这些符号因为其实上面的匹配器都是方法调用我们只需要**should\_not**就可以做
相反匹配。


### Predicate Matchers
这种匹配器针对ruby中的predicate方法,这些方法以?结尾,返回一个Boolean值.

    array.empty?.should == true
    等于
    array.should be_empty
    
Rspec通过method_missing给我们提供一个语法糖,使测试表达跟加直观,加入那个missing method以"be_"开头, Rspec将去掉"be\_",然后在后面追加"?",最后其实就是将第二种写法变回了第一种写法.同时它还支持"be\_a" 和 "be\_an"    


### True/False 匹配
 **be_true 和 be_false**: 这两个方法用匹配那些在ruby代码中返回值被**求解为true或false的**
 
     true.should be_true
     0.should be_false
     
### have匹配器
  
 1. Rspec在处理对象中以"has_"开头的方法,在Rspec测试中它封装成以"have\_":
 
        requeste.has_key?(:id).should == true
        等于
        requeste.should have_key(:id)

 2. 当一个对象不是collection时:
 
        field.player.select{|p| p.team == home_team}.length.should == 9
        
        我们更加ruby化进行描述:
        
        home\_team.should have(9).players\_on(field)
        
        这时候由于have(9)返回的对像没有players_on方法,Rspec就把这个方法分派到了前面home_team对象上了:
        
        home_team.player_on(field).should have(9)
        这个测试collection的length
  
 3. 当对象本身是一个collection:
  
        collection.should have(7).items
        
        这时候的have(7)后面的items就会被Rspec当作语法糖的作用实际就是:
        collection.should have(7)
        
这个have本身都是调用collection的size或是length来测试集合的长度

### Precision in Collecion Expectations

 1. have_exactly: 表示精确匹配
 
        day.should have_exactly(24).hours
    
 2. have\_at\_least: 表示至少需要多少
 
        dozen.should have\_at\_least(12).bagels
        
 3. have\_at_\_most: 表示至多
 
        a_class have\_at_\_most(40).students
        
### 操作符匹配

    result.should == 3
    result..should =~ /***/
    result.should be < 7
    result.should be <= 7
    result.should be >= 7
    result.should be > 7
    
### subject
  subject块中我们放我们要描述的对象, 其实我们可以在before或是subject对对象进行实例化.
  
  1. Explicit Subject
  
        describe Person do
          subject{Person.new(:birthday => 19.years.ago)}
          specify{ subject.should be_eligible_to_vote }
        end
        
  2. Delegation to subject
  
        describe Person do
          subject{Person.new(:birthday => 19.years.ago)}
          it{should be_eligible_to_vote}
        end
        这里should没有指定接收者,因此example它自己就进行接收,这个example调用subject,然后把should方法添加给subject



### 其他例子

    actual.should be_nil   # passes if actual is nil
    
    expect { |b| 5.tap(&b) }.to yield_control # passes regardless of yielded args
    expect { |b| yield_if_true(true, &b) }.to yield_with_no_args # passes only if no args are yielded
    expect { |b| 5.tap(&b) }.to yield_with_args(5)
    expect { |b| 5.tap(&b) }.to yield_with_args(Fixnum)
    expect { |b| "a string".tap(&b) }.to yield_with_args(/str/)
    expect { |b| [1, 2, 3].each(&b) }.to yield_successive_args(1, 2, 3)
    expect { |b| { :a => 1, :b => 2 }.each(&b) }.to yield_successive_args([:a, 1], [:b, 2])

    (1..10).should cover(3) #期望一个集合中包含某值
    actual.should include(expected)
    
    actual.should start_with(expected)
    actual.should end_with(expected)

## 配置语法
 
    RSpec.configure do |config|
      config.expect_with :rspec do |c|
        c.syntax = :expect
        # or
        c.syntax = :should
        # or
        c.syntax = [:should, :expect]
      end
    end

## 一个语法
  做了这样的配置：config.syntax = :expect


     describe User do
       it { should validate_presence_of :email }
     end
