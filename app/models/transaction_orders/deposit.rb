module TransactionOrders
  class Deposit < TransactionOrder
    include Transactions
    belongs_to :origin_account, class_name: 'Account', foreign_key: 'id'
    belongs_to :destination_account, class_name: 'Account', foreign_key: 'id'
    has_one :credit, class_name: 'Transactions::Credit', foreign_key: 'transaction_order_id'

    validates :destination_account,
      presence: true

    def execute!
      Deposit.transaction do
        Credit.create!(financial_account: destination_account, value: value, transaction_order: self)
        self.state = 'executed'
        self.state_date = Time.zone.now
      end
      self.save!
      self
    rescue Exception => ex
      self.state = 'error'
      self.state_date = Time.zone.now
      self.state_reason = ex.message
      self.save!
      self
    end

    def to_s
      'Manual deposit'
    end
  end
end
