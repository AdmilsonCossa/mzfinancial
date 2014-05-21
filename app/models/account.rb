class Account < ActiveRecord::Base
  #attr_accessible :balance, :number
  
  autocomplete :display_name,
   result_fetcher: ->(query) do
      joins(:Participant).where('LOWER("participants"."name") LIKE LOWER(?)',
        autocomplete_query(query),
      ).order('"participants"."name"')
    end

  belongs_to :holder, 
    class_name: 'Participant',
    foreign_key: 'holder_id'
  
  belongs_to :bank 

  validates :number, :holder, :bank,
    presence: true

  def display_name
    "#{holder.name} #{number || '<ephemeral>'}"
  end

  def to_s
    display_name
  end
end
