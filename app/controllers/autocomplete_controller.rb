class AutocompleteController < ApplicationController
  # before_filter :authenticate_admin_user!
  # around_filter :with_tenant!, if: :admin_user_signed_in?

  def index
    respond_to do |format|
      format.json {
        render :json => autocomplete_results
      }
    end
  end

  private

  def autocomplete_results
    query_term.present? ? model.autocomplete_results(query_term) : []
  end

  def model
    params[:model].classify.constantize
  end

  def query_term
    params[:q]
  end
end
