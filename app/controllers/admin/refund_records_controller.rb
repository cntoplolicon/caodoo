class Admin::RefundRecordsController < Admin::AdminController
  def index
    respond_to do |format|
      format.html
      format.json { render json: ::RefundRecordDatatable.new(view_context) }
      format.csv { render text: ::RefundRecordDatatable.new(view_context).as_json }
    end
  end
end
