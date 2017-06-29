require 'rubygems'
require 'net/http'
require 'json/ld'

class Account < ActiveRecord::Base
  belongs_to :user

  has_many :sent_messages, class_name: 'Message', foreign_key: 'account_id'
end
