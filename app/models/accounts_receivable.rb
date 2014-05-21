class AccountsReceivable < ActiveRecord::Base
  
  autocomplete :participant,
    result_fetcher: ->(query){
      p = arel_table
      cp = Object.const_get(:participant).arel_table # Fuck you, ActiveSupport's Reload!

      joins(
        'LEFT OUTER JOIN "contact_points" ON "contact_points"."participant_id" = "interveners"."id"'
      ).where(
        cp[:value].matches(autocomplete_query(query)).or(p[:name].matches(autocomplete_query(query)))
      ).includes(:contact_points).order('name') # If a Symbol is used here, Rails breaks!
    },
    format_label: ->(record){
      ''.tap do |out|
        out << "<b>#{record.to_s}</b><br/>"
        out << '<ul>'
        record.contact_points.each do |cp|
          out << "<li>#{cp.class.name.humanize}: #{cp.value}</li>"
        end
        out << '</ul>'
      end
    }

  belongs_to :participant
  belongs_to :financial_category
  belongs_to :expense_type
  belongs_to :account

  validates :participant, :financial_category, :expense_type, :account, :value,
  :document_serie, :document_number, :issue_date, :due_date,
    presence: true

end
