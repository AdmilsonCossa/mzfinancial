class TransactionOrder < ActiveRecord::Base
  #attr_accessible :description, :value, :state, :state_date

  has_many :transactions


  TRANSACTION_ORDER_STATES = %w(pending error executed).each do |st|
    scope st, where(state: st)
    define_method "#{st}?" do
      state.to_s == st
    end
    define_method "was_#{st}?" do
      state_was.to_s == st
    end
  end

  validates :state,
    presence: true,
    inclusion: { within: TRANSACTION_ORDER_STATES + TRANSACTION_ORDER_STATES.map(&:to_sym) }

  validates :value, :numericality => { :greater_than_or_equal_to => 1 }

  def initialize(*args)
    super(*args)
    self.state ||= :pending
    self.state_date ||= Time.zone.now
  end

  def create
    super
    self.execute!
  end
end
