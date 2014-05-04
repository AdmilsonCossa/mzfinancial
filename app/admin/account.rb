ActiveAdmin.register Account do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
   permit_params :number, :holder, :bank
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  index do
    selectable_column
    id_column
    column :number
    column :holder
    column :bank
    column :created_at
    actions
  end

  filter :number
  filter :holder
  filter :bank
  filter :created_at

  form do |f|
    f.inputs "Account Details" do
      f.input :number
      f.input :holder
      f.input :bank
    end
    f.actions
  end
  
end
