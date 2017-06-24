class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = :email
  end

  has_many :sent_messages, class_name: 'Message'
end
