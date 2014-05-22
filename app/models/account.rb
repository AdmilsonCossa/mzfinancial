class Account < ActiveRecord::Base
  #attr_accessible :balance, :number
  
  autocomplete :number
  autocomplete :name,
      result_fetcher: ->(query){
        p = arel_table
        participant = Object.const_get(:Participant).arel_table # Fuck you, ActiveSupport's Reload!

        joins(
          'LEFT OUTER JOIN "participants" ON "participants"."id" = "accounts"."holder_id"'
        ).where(
          participant[:name].matches(autocomplete_query(query)).or(p[:number].matches(autocomplete_query(query)))
        ).order('name') # If a Symbol is used here, Rails breaks!
      },
      format_label: ->(record){
        ''.tap do |out|
          out << "<b>#{record.to_s}</b><br/>"
          if record.methods.include?(:participants)
            out << '<ul>'
            record.participants.each do |parti|
              out << "<li>#{parti.class.name.humanize}: #{parti.name}</li>"
            end
            out << '</ul>'
          end
        end
      }

  belongs_to :holder, 
    class_name: 'Participant', foreign_key: 'holder_id'
  
  belongs_to :bank 

  validates :number, :holder, :bank, presence: true

  def display_name
    "#{holder.name} #{number || '<ephemeral>'}"
  end

  def to_s
    display_name
  end
end
