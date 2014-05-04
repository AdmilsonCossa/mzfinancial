class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :name
      t.references :account, index: true

      t.timestamps
    end
  end
end
