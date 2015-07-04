class Admin::OrdersController < Admin::AdminController
  def index
    respond_to do |format|
      format.html
      format.json { render json: ::OrderDatatable.new(view_context) }
      #format.csv { render text: to_csv(::RefundRecordDatatable.new(view_context).unpaged_records) }
    end
  end

  def edit
  end
end
