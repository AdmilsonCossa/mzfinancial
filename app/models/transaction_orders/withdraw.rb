module TransactionOrders
  class Withdraw < TransactionOrder
    include Transactions
    belongs_to :destination_account, class_name: 'Account', foreign_key: 'id'
    belongs_to :origin_account, class_name: 'Account', foreign_key: 'id'
    has_one :debit, class_name: 'Transactions::Debit', foreign_key: 'transaction_order_id'

    validates :origin,
      presence: true

    def execute!
      Withdraw.transaction do
        if origin.reload.balance >= value
          Debit.create!(financial_account: origin_account, value: -value, transaction_order: self)
          self.state = 'executed'
          self.state_date = Time.zone.now
        else
          self.state = 'error'
          self.state_date = Time.zone.now
          self.state_reason = 'Not enough balance!'
        end
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
      'Manual withdraw'
    end
  end
end
