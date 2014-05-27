class AccountsPayable < ActiveRecord::Base

  autocomplete :participant,
   result_fetcher: ->(query) do
      joins(:Participant).where('LOWER("participants"."name") LIKE LOWER(?)',
        autocomplete_query(query),
      ).order('"participants"."name"')
    end
   
  belongs_to :participant
  belongs_to :financial_category
  belongs_to :expense_type
  belongs_to :account

  after_create :check_due_date
  before_save  :initialize_states

  validates :participant, :financial_category, :expense_type, :account, :value,
    :document_serie, :document_number, :issue_date, :due_date,
    presence: true

  def check_due_date
    # You can now check the "due" field here. For example, if you only want to allow due
    # dates today and later:
    if self.due_date < Date.today or self.due_date < self.issue_date
      errors.add(:due_date, "can only be today or later.")
    end
  end

  def initialize_states
    self.state = 'not factured'
    self.term_state = 'in time' if Date.today <= self.due_date
  end

end
