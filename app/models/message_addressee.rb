class MessageAddressee < ActiveRecord::Base
  belongs_to :message
  belongs_to :account
end
