class Bank < ActiveRecord::Base
  
  autocomplete :name
  belongs_to :account
end
