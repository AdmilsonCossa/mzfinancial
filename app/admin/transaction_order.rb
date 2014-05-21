%w(Transfer Deposit Withdraw).each do |klass_name|
  klass = TransactionOrders.const_get(klass_name)
  ActiveAdmin.register klass, as: klass_name do

    actions :show, :index, :new, :create

    permit_params :state, :value, :id
    
    filter :created_at
    filter :updated_at

    controller do
      def scoped_collection
        super.preload(
          :origin_account,
          :destination_account,
        )
      end
    end

    index do
      id_column
      case
      when klass == TransactionOrders::Transfer
        column :origin_account
        column :destination_account
      when klass == TransactionOrders::Deposit
        column :destination_account
      when klass == TransactionOrders::Withdraw
        column :origin_account
      end
      case
      when klass == TransactionOrders::Transfer
      column :state do |transfer|   
        status_tag(transfer.state, (transfer.state == 'executed' ? :ok : :warning))
        end
      when klass == TransactionOrders::Deposit
        column :state
      when klass == TransactionOrders::Withdraw
        column :state
      end
      column :value
      column :created_at
      column :updated_at
      default_actions
    end

    show do
      attributes_table do
        row :id
        case resource
        when TransactionOrders::Transfer
          row :origin_account
          row :destination_account
          row(:debit) { |t| t.debit.try(:id) }
          row(:credit) { |t| t.credit.try(:id) }
        when TransactionOrders::Deposit
          row :destination_account
          row(:credit) { |t| t.credit.try(:id) }
        when TransactionOrders::Withdraw
          row :origin_account
          row(:debit) { |t| t.debit.try(:id) }
        end
        row :value
        row :state 
        row :state_date
        row :description
        row :created_at
        row :updated_at
      end
    end

    form do |f|
      f.inputs do
        case resource
        when TransactionOrders::Transfer
          if params[:financial_account]
            f.input :origin_account,
              :input_html => { "data-pre" => [{id: params[:financial_account].id, name: Account.find(params[:financial_account]).to_s}].to_json }
          else
            f.input :origin_account
          end
          f.input :destination_account
        when TransactionOrders::Deposit
          if params[:financial_account]
            f.input :destination_account,
              :input_html => { "data-pre" => [{id: params[:financial_account], name: Account.find(params[:financial_account]).to_s}].to_json }
          else
            f.input :destination_account
          end
        when TransactionOrders::Withdraw
          if params[:financial_account]
            f.input :origin_account,
              :input_html => { "data-pre" => [{id: params[:financial_account], name: Account.find(params[:financial_account]).to_s}].to_json }
          else
            f.input :origin_account
          end
        end
        f.input :value
      end
      f.actions
    end
  end
end
