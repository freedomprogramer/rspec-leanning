require 'spec_helper.rb'

describe MessagesController do
  describe "GET index" do
    it "assigns @messages" do
      message = Message.create
      get :index
      assigns(:messages).should eq([message])
    end

    it "renders the index template" do 
      get :index
      response.should render_template("index")
    end
  end

  describe "POST create" do
    let(:message){ mock_model(Message).as_null_object }
    before{ Message.stub(:new).and_return(message) }

    it "create a new message" do
      Message.should_receive(:new).with("content" => "hello rspec")

      post :create, message: {"content" => "hello rspec"}
    end

    context "when the message saves succfully" do
      it "should render index page" do
        post :create
        response.should redirect_to(action: "index")
      end

      it "sets a flash[:notice] message" do
        post :create
        flash[:notice].should =~ /post/
      end
    end

    context "when the message saves failed" do
      it "assigns @message " do
        message.stub(:save).and_return(false)
        post :create
        assigns[:message].should eq(message)
      end

      it "should render new template" do
        message.stub(:save).and_return(false)
        post :create 
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:message) { mock_model(Message) }

    it "find exist message" do
      Message.should_receive(:find).and_return(message)

      put :update, "id" => "1"
    end

    context "update attributes success" do
      it "should redirect to  index page" do
      end
    end

    context "update attributes failed" do
      
    end
  end
end
