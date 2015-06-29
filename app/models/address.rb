class Address < ActiveRecord::Base
  belongs_to :user

  belongs_to :province, class_name: 'Region', foreign_key: 'province_code', primary_key: 'code'
  belongs_to :city, class_name: 'Region', foreign_key: 'city_code', primary_key: 'code'
  belongs_to :district, class_name: 'Region', foreign_key: 'district_code', primary_key: 'code'

  validates :receiver, presence: true
  validates :detailed_address, presence:  true
  validates :phone, presence:  true
  validates_format_of :phone, with: /\A[^a-zA-Z]*\z/
end
