# rspec 第四步
rspec-rails 是为rails做的封装。

## 安装
在Gemfile中添加:

  group :test, :development do
    gem "rspec-rails"
    gem "factory-girls"
    gem "capybara"
  end

然后运行（帮助增加spec目录， 和rake spec命令）:
rails generate rspec:install

安装后将如果使用rails generate命令将会自动使用spec文件替换原来的Test::Unit
## Model测试
model测试文件在spec/model目录下面, 建议这里以行为测试驱动， 完成后补充单元测试保护成功。

eg:
  require "spec_helper"

  describe User do
    it "orders by last name" do
      lindeman = User.create!(first_name: "Andy", last_name: "Lindeman")
      chelimsky = User.create!(first_name: "David", last_name: "Chelimsky")

      expect(User.ordered_by_last_name).to eq([chelimsky, lindeman])
    end
  end

## Controller测试
controller测试文件放在spec/controller目录下面， 这里直接做行为驱动测试
  require "spec_helper"

  describe PostsController do
    describe "GET #index" do
      it "responds successfully with an HTTP 200 status code" do
        get :index
        expect(response).to be_success
        expect(response.code).to eq(200)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end

      it "loads all of the posts into @posts" do
        post1, post2 = Post.create!, Post.create!
        get :index

        expect(assigns(:posts)).to match_array([post1, post2])
      end
    end
  end

## Request测试
request测试放在spec/requests spec/api spec/integration目录下面， 混入(mixin)了
rails的ActionDispatch::Integration::Runner的行为(rails原生提供的测试api， 如get post方法)
目的是指定一个或者多个request/response循环回归黑盒测试。

eg:
﻿﻿  require 'spec_helper'
  describe "home page" do
    it "displays the user's username after successful login" do
      user = User.create!(:username => "jdoe", :password => "secret")
      get "/login"
      assert_select "form.login" do
      assert_select "input[name=?]", "username"
      assert_select "input[name=?]", "password"
      assert_select "input[type=?]", "submit"
    end

      post "/login", :username => "jdoe", :password => "secret"
      assert_select ".header .username", :text => "jdoe"
    end
  end

  # 安装FactoryGirl 和 Capybara
  require 'spec_helper'
  describe "home page" do
    it "displays the user's username after successful login" do
      user = FactoryGirl.create(:user, :username => "jdoe", :password => "secret")
      visit "/login"
      fill_in "Username", :with => "jdoe"
      fill_in "Password", :with => "secret"
      click_button "Log in"

      expect(page).to have_selector(".header .username", :text => "jdoe")
    end
  end

  FactoryGirl创建测试需求改变对象依赖的对象， 这样把测试需求依赖对象和测试对象本身进行分离
  Capybara简化了表单验证操作

## View测试
放在spec/views下面， 混入了(mix)ActionView::TestCase::Behavior(rails原生为页面测试提供api)

eg:
  require 'spec_helper'
  describe "events/index" do
    it "renders _event partial for each event" do
      assign(:events, [stub_model(Event), stub_model(Event)])
      render
      expect(view).to render_template(:partial => "_event", :count => 2)
    end
  end

  describe "events/show" do
    it "displays the event location" do
      assign(:event, stub_model(Event,
        :location => "Chicago"
      ))
      render
      expect(rendered).to include("Chicago")
    end
  end

注意:
  describe 做example groups表述的时候， 如"events/index"就是按照"app/view/events/index.html.erb"
  这样的路径描述的。这样自动测试这些值:
  controller.controller_path == "events"
  controller.request.path_parameters[:controller] == "events"
  如果你在一个测试组(example groups)里面包含多个路径， 需要在example里面手动改变这些值.
  模板需要手动指定:
  render :template => "events/show", :layout => "layouts/application"


## assign(key, val)
   assign 为页面设定变量值
   assign(:widget, stub_model(Widget))
   render
   为页面设定一个stub对象@widget

   因为view测试混入（mix）了 ActionView::TestCase， 所以这样写也可以（controller测试同样）
   @widget = stub_model(Widget)
   render # @widget is available inside the view

   注意： 最好不要这样写， 因为将来rspec可能不会支持这样的写法

## rendered
   代表请求回来的页面

## Routing 测试
放在spec/routing下面

  require 'spec_helper'
    describe "routing to profiles" do
    it "routes /profile/:username to profile#show for username" do
      expect(:get => "/profiles/jsmith").to route_to(
        :controller => "profiles",
        :action => "show",
        :username => "jsmith"
      )
    end

    it "does not expose a list of profiles" do
      expect(:get => "/profiles").not_to be_routable
    end
  end

## Helper测试
放在spec/helpers目录下面， 混入了ActionView::TestCase::Behavior
提供了一个helper对象混入测试的helper模块， 包含ApplicationHelper

  require 'spec_helper'
  describe EventsHelper do
    describe "#link_to_event" do
      it "displays the title, and formatted date" do
        event = Event.new("Ruby Kaigi", Date.new(2010, 8, 27))
        # helper is an instance of ActionView::Base configured with the
        # EventsHelper and all of Rails' built-in helpers
        expect(helper.link_to_event).to match /Ruby Kaigi, 27 Aug, 2010/
      end
    end
  end

## 匹配器
### be_a_new
1. 所有类型测试有效
2. 主要使用在controller测试中

eg:
  expect(object).to be_a_new(Widget)

###render_template
1. 代替rails assert_template
2. 在request controller view测试有效
eg:
  # 在request controller 应用在response对象
  expect(response).to render_template("new")

  # 在view测试 应用在view对象
  expect(view).to render_template(:partial => "_form", :locals => { :widget => widget } )

### redirect_to
1. 代替assert_redirect
2. 在request 和 controller测试有效
eg:
  expect(response).to redirect_to(widgets_path)

### route_to
1. 代替assert_routing
2. 在controller 和 routing测试有效
eg:
  expect(:get => "/widgets").to route_to(:controller => "widgets", :action => "index")

### be_routable
主要routing测试， 一般是测试not情况如:
  expect(:get => "/widgets/1/edit").not_to be_routable

## rake命令
rake -T | grep rspec

## 定制rspec命令
像这样定制task
  task("spec").clear

## webrat 和 capybara
都可以模拟浏览器
