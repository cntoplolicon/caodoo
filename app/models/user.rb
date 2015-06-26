class User < ActiveRecord::Base
  attr_accessor :security_code

  has_secure_password validations: false

  validates_presence_of :username
  validates_format_of :username, with: /\A\d{11}\z/
  validates_presence_of :password, on: :create
  validates_format_of :password, with: /\A[ -~]{6,20}\z/, on: :create
  validates :terms_of_service, acceptance: true, on: :create
end
