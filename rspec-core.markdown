# Rspec测试驱动开发基础

行为驱动设计(BDD) 领域驱动设计(Domain Driven Design) 验收测试驱动设计(Acceptance Test-Driven Planning)

## rspec结构基础
 Rspec包含以下几个基本的gem:
 
 1. rspec-core
 2. rspec-expectations
 3. rspec-mocks
 4. rspec-rails

## 安装
 gem install rspec


## 基本结构
  describe 和 it 一起进行使用， describe用于描述**一组**code exampel， 而 it 用与描述具体的**一个**code example

    describe Thing do 
      it "does something" do 
        do somthig
      end
    end

### 嵌套组
  使用describe 和 context 都可以进行ExampleGroup的嵌套，本质上 context 就是 describe 的一个**别名**， 
 但是describe通常使用在最外层对一个大的example进行描述。 context一般用于描述的是一个情况下一类code example的
 情况，它的内层一般紧跟一个it。

  在描述example中it、specify、example都可以，因为它们都是example的别名。我们可以根据描述语义对它们进行灵活使用。


    describe Order do
      context "with no items" do
        it "behaves one way" do
          # ...
        end
      end

      describe "with one item" do
        it "behaves another way" do
          # ...
        end
      end
  end

### 原属性(metadata)
  metadata是rspec-core提供给任何一个group 或者example的一个hash， 里面包含了他们的表述属性， 一个hash包含很多group example很多输出的信息(如描述，位置：就是属于那层嵌套的group或者example, 甚至before和after等hook信息)

    it "does something" do
      expect(example.metadata[:description]).to eq("does something")
    end

### 共享测试组
  shared\_examples include\_examples 配对使用shared\_examples 可以定义任何东西，包含了before after around(hooks), let(defintions), nested groups/contexts
 
  shared\_context include\_context也可以， 但是一般他们内部多放before after around(hooks), let(defintions)， help methods不包含examples


    shared_examples "collections" do |collection_class|
      it "is empty when first created" do
        expect(collection_class.new).to be_empty
      end
    end

    describe Array do
      include_examples "collections", Array
    end

    describe Hash do
      include_examples "collections", Hash
    end

#### describe_class

  如果传递给describe是一个类(class), 那么可以通过describe_class来获取这个类， 本质是example.metadata[:describe\_class]的一个封装。
当你在扩展或者共享组(example groups)无法确定测试的是那个类(class)的时候.


    shared_examples "collections" do
      it "is empty when first created" do
        expect(described_class.new).to be_empty
      end
    end

    describe Array do
      include_examples "collections"
    end

    describe Hash do
      include_examples "collections"
    end

## 其他

### 命令
   rspec...
   详细参考: rspec --help

### .rspec文件
  在自己的根目录或者项目的根目录下面放一个.rspec文件可以加入需要输入的参数


### 测试自动化集成
  autotest(gem) https://github.com/rspec/rspec/wiki/autotest


### 测试覆盖率集成
  simplecov https://github.com/colszowka/simplecov
