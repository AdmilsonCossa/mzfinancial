class AddColumnStateToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :state, :string
  end
end
