class CreateAccountsPayables < ActiveRecord::Migration
  def change
    create_table :accounts_payables do |t|
      t.references :participant, index: true
      t.references :financial_category, index: true
      t.references :expense_type, index: true
      t.references :account, index: true
      t.datetime :issue_date
      t.datetime :due_date
      t.decimal :value
      t.text :description
      t.string :document_serie
      t.string :document_number
      t.string :term_state
      t.string :state

      t.timestamps
    end
  end
end
