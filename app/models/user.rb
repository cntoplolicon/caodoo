class User < ActiveRecord::Base
  attr_accessor :security_code
  attr_accessor :updating_password

  has_secure_password validations: false

  validates_presence_of :username
  validates_format_of :username, with: /\A\d{11}\z/
  validates_presence_of :password, if: :should_validate_password?
  validates_format_of :password, with: /\A[ -~]{6,20}\z/, if: :should_validate_password?
  validates :terms_of_service, acceptance: true
  validates_confirmation_of :password, if: :should_validate_password?

  has_many :addresses
  has_many :orders
  has_many :coupons

  def should_validate_password?
    updating_password || new_record?
  end

end
