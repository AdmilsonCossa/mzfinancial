class Account < ActiveRecord::Base
  #attr_accessible :balance, :number
  
  belongs_to :holder, 
    class_name: 'Participant',
    foreign_key: 'holder_id'
  
  belongs_to :bank 

  validates :number,
    presence: true

  validates :holder,
    presence: true

  validates :bank,
    presence: true
end
