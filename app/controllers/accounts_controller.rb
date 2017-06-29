class AccountsController < ApplicationController
  def show
    @account = Account.find_by(username: params[:id]) || Account.find(params[:id])

    raise ActionController::RoutingError.new('User not found.') unless @account.user

    respond_to :html, :json
  end

  def new_remote
    @errors = []
  end

  def create_remote
    url = params[:url]

    account = find_existing_account(url)

    return redirect_to home_path if account

    account = Factories::AccountFactory.from_activitystreams2_url(url)

    if account.save
      flash[:notice] = "Account registered!"
      redirect_to home_path
    else
      @errors = ["User not found."]
      render :action => :new_remote
    end
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
