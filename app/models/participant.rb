class Participant < ActiveRecord::Base
  
  autocomplete :name
  belongs_to :account

end
