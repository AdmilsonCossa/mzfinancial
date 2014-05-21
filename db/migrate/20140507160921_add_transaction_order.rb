class AddTransactionOrder < ActiveRecord::Migration
  def change
    create_table :transaction_orders do |t|
      t.float :value
      t.string :description
      t.string :state
      t.datetime :state_date

      t.timestamps
    end
  end
end
