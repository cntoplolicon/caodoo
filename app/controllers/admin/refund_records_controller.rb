class Admin::RefundRecordsController < Admin::AdminController
  def index
    respond_to do |format|
      format.html
      format.json { render json: ::RefundRecordDatatable.new(view_context) }
    end
  end
end
