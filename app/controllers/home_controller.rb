class HomeController < ApplicationController
  before_filter :require_user, only: [:show]

  def show
    @accounts = Account.all
  end
end
