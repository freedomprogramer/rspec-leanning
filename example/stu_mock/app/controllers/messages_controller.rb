class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def create
    @message = Message.new(params[:message])
    
    if @message.save
      redirect_to messages_path, :notice => "post sucessful"
    else
      render "new"
    end
  end

  def update
    @message = Message.find(params[:message])
    redirect_to messages_path
  end
end
