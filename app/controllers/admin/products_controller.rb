class Admin::ProductsController < Admin::AdminController
  def index
    respond_to do |format|
      format.html
      format.json { render json: ::ProductDatatable.new(view_context) }
    end
  end
end
