class CreateFinancialCategories < ActiveRecord::Migration
  def change
    create_table :financial_categories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
