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

 validates :participant, :financial_category, :expense_type, :account, :value,
  :document_serie, :document_number, :issue_date, :due_date,
    presence: true
end
