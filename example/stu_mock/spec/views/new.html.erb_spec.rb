require 'spec_helper'

describe "messages/new.html.erb" do
  let(:message) do
    mock_model("Message").as_new_record.as_null_object
  end

  before do
    assign(:message, message)
  end

  it "renders a form to create a message" do
    render 
    rendered.should have_selector("form",
      :method => "post",
      :action => messages_path
    ) do |form|
      form.should have_selector("input", :type => "submit")
    end
  end

  it "renders a text field for the message title" do
    message.stub(:title => "the title")
    render

    rendered.should have_selector("form", 
      :method => "post",
      :action => messages_path) do |form|
      form.should have_selector("input",
        :type => "text",
        :name => "message[title]",
        :value => "the title"
      )
    end
  end

end
