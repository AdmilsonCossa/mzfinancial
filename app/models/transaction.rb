class Transaction < ActiveRecord::Base
  #attr_accessible :value, :description, :account, :transaction_order

  belongs_to :account, class_name: 'Account'
  belongs_to :transaction_order
end
