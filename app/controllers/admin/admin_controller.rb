class Admin::AdminController < ApplicationController
  http_basic_authenticate_with name: Settings.admin.username, password: Settings.admin.password

  layout 'admin'
end
