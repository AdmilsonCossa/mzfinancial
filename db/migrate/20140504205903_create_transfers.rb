class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.text :description
      t.references :origin_account, index: true
      t.references :destination_account, index: true
      t.decimal :value

      t.timestamps
    end
  end
end
