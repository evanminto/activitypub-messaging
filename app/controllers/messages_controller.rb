class MessagesController < ApplicationController
  before_filter :require_user

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user = @current_user
    if @message.save
      flash[:notice] = "Message sent!"
      redirect_to home_path
    else
      render action: :new
    end
  end

  def message_params
    params.require(:message).permit(
      :content
    )
  end
end
