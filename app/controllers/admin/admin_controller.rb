class Admin::AdminController < ApplicationController
   http_basic_authenticate_with name: "caodoo-admin", password: "Passw0rd"

  layout 'admin'
end
