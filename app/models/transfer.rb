class Transfer < ActiveRecord::Base
  attr_accessible :origin_account, :destination_account, :value

  belongs_to :origin_account, class_name: 'Account'
  belongs_to :destination_account, class_name: 'Account'
end
