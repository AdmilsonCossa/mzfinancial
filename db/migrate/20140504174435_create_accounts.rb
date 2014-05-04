class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :number
      t.decimal :balance
      t.references :holder, index: true
      t.references :bank, index: true

      t.timestamps
    end
  end
end
