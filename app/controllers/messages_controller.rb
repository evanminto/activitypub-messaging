class MessagesController < ApplicationController
  before_filter :require_user

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.account = @current_user.account

    addressee_account = find_existing_account(params[:message][:addressees_attributes][0][:url])

    unless addressee_account
      addressee_account = Factories::AccountFactory.from_activitystreams2_url(params[:message][:addressees_attributes][0][:url])
    end

    @message.addressees.build(account: addressee_account, target_type: params[:message][:addressees_attributes][0][:target_type])

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

  def find_existing_account(url)
    account_url = URI(url)
    base_url = URI(request.base_url)

    if account_url.host == base_url.host && account_url.port == base_url.port
      route = Rails.application.routes.recognize_path(account_url.path)

      if route[:controller] == 'accounts' && route[:action] == 'show'
        return Account.find_by(username: route[:id]) || Account.find(route[:id])
      end
    end

    Account.find_by activitystreams2_url: url
  end
end
