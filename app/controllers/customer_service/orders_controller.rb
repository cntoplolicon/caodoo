class CustomerService::OrdersController < CustomerService::CustomerServiceController
  def index
    respond_to do |format|
      format.html
      format.json { render json: ::CustomerServiceOrderDatatable.new(view_context) }
    end
  end

  def show
    @order = Order.find(params[:id])
  end

end
