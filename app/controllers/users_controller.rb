class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]

  def new
    @user = User.new
    @user.account = Account.new
  end

  def create
    @user = User.new user_params
    @user.active = true
    @user.approved = true
    @user.confirmed = true
    if @user.save
      flash[:notice] = "Account registered!"
      UserSession.create @user
      redirect_to home_path
    else
      render :action => :new
    end
  end

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      account_attributes: [
        :username,
        :display_name
      ]
    )
  end
end
