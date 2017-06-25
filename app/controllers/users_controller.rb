class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.active = true
    @user.approved = true
    @user.confirmed = true
    if @user.save
      flash[:notice] = "Account registered!"
      UserSession.create @user
      redirect_back_or_default user_path(@user)
    else
      render :action => :new
    end
  end

  def show
    @user = User.find_by(username: params[:id]) || User.find(params[:id])

    respond_to :html, :json
  end

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :username,
      :name
    )
  end
end
