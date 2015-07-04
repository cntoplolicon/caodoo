class Admin::OrdersController < Admin::AdminController
  def index
    respond_to do |format|
      format.html
      format.json { render json: ::OrderDatatable.new(view_context) }
      format.csv { render text: to_csv(::OrderDatatable.new(view_context).unpaged_records) }
    end
  end

  def to_csv(records)
    CSV.generate do  |csv|
      csv << ['订单号', '商品名称']
      records.each do |r|
        csv << [r.order_number, r.product.name]
      end
    end
  end


  def edit
  end
end
