ActiveAdmin.register AccountsReceivable do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  permit_params :participant, :account, :financial_category, :description, :expense_type

  controller do
    def scoped_collection
      collection = super.includes(
        :participant,
        :account,
      )
      collection
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
  
end
