class Transfer < ActiveRecord::Base
  attr_accessible :origin_account, :destination_account, :value

  belongs_to :origin_account, class_name: 'Account'
  belongs_to :destination_account, class_name: 'Account'

  validates :origin_account, :destination_account, :value
      presence: true
  
  def execute_transfer!
    raise "Transference already executed!" if state == 'executed'
      if origin_account.balance >= value
        origin_account.debit(value)
        destination_account.credit(value)
        self.state = 'executed'
        self.state_datetime = Time.zone.now
      else
        self.state = 'failed'
        self.state_datetime = Time.zone.now
        elf.state_reason = 'Not enough balance!'
      end
      self.save
      self
    rescue Exception => ex
      self.state = 'failed'
      self.state_datetime = Time.zone.now
      self.state_reason = ex.message
      self.save!
      self
  end
end
