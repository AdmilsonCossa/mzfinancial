class AccountsReceivable < ActiveRecord::Base
  
  autocomplete :participant
  
  belongs_to :participant
  belongs_to :financial_category
  belongs_to :expense_type
  belongs_to :account

  after_create :check_due_date

  # validates :participant, :financial_category, :expense_type, :account, :value,
  # :document_serie, :document_number, :issue_date, :due_date,
  #   presence: true

  def check_due_date
    # You can now check the "due" field here. For example, if you only want to allow due
    # dates today and later:
    if self.due_date < Date.today or self.due_date < self.issue_date
      errors.add(:due_date, "can only be today or later.")
    end
  end

  def initialize_sate!
    self.state = 'not factured'
    account_receivable.term_state = 'in time' if Date.today <= account_receivable.due_date
    self.save    
  end

  def confirm(account_receivable)
    raise 'already factured' if state == 'factured'
    #account_receivable.account.debit(account_receivable.value)
    account_receivable.state = 'factured'
    if(Date.today <= account_receivable.due_date)
      account_receivable.term_state = 'in time'
    else
      account_receivable.term_state = 'Late'
    end
    account_receivable.save!
  end
end
