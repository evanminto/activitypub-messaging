class Message < ActiveRecord::Base
  belongs_to :account
  has_many :addressees, class_name: 'MessageAddressee'
end
