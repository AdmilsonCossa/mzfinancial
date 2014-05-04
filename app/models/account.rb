class Account < ActiveRecord::Base
  #attr_accessible :balance, :number
  belongs_to :holder, 
    class_name: 'Participant',
    foreign_key: 'holder_id'
  belongs_to :bank 
end
