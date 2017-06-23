class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = :email
  end
end
