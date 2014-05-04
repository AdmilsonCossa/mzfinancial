class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :name
      t.references :account, index: true

      t.timestamps
    end
  end
end
