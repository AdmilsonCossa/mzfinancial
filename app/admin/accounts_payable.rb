ActiveAdmin.register AccountsPayable do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :participant_id, :document_serie, :document_number,
    :issue_date, :due_date, :value, :account_id,
    :financial_category_id, :expense_type_id
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  controller do
    def scoped_collection
      collection = super.includes(
        :participant,
        :account,
      )
      collection
    end
  end

  index do
    selectable_column
    id_column
    column :due_date
    column :participant
    column :description
    column :state do |ac_r| status_tag(ac_r.state, (ac_r.state == 'factured' ? :ok : :warning)) end
    column :value
    column :account
    column :term_state do |ac_r| status_tag(ac_r.term_state, (ac_r.term_state == 'In time' ? :ok : :red)) end
    
    actions default: true do |acc_rec| 
      link_to('confirm', confirm_admin_accounts_receivable_path(acc_rec))
    end
  end

  form do |f|
    f.inputs "Account Receivable" do
      f.input :participant
      f.input :document_serie
      f.input :document_number
      f.input :issue_date, :as => :string, :input_html => {:class => "datepicker"}
      f.input :due_date, :as => :string, :input_html => {:class => "datepicker"}
      f.input :value
      f.input :account
      f.input :financial_category
      f.input :expense_type
      f.input :description
    end

    f.actions
  end

  member_action :facture, :method => :put do
    @acc_payee = AccountsReceivable.find(params[:id])

    if @acc_payee.state == 'factured'
      flash[:alert] = "Already factured"
      redirect_to :action => :index
    else
      acc_payee.confirm_payee!
      redirect_to(
        confirm_admin_accounts_payable_path(resource.facture),
        notice: "Payable sucessfully factured."
      )
    end
  end
end
    