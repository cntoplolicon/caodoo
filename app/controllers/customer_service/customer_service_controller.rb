class CustomerService::CustomerServiceController < ApplicationController

  http_basic_authenticate_with name: Settings.customer_service.username, password: Settings.customer_service.password
  layout 'customer_service'

end
