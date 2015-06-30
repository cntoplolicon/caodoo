class Address < ActiveRecord::Base
  belongs_to :user

  belongs_to :province, class_name: 'Region', foreign_key: 'province_code', primary_key: 'code'
  belongs_to :city, class_name: 'Region', foreign_key: 'city_code', primary_key: 'code'
  belongs_to :district, class_name: 'Region', foreign_key: 'district_code', primary_key: 'code'

  validates :receiver, presence: true
  validates :detailed_address, presence: true
  validates :phone, presence:  true
  validates :province_code, presence: true
  validates :city_code, presence: true, if: :province_has_cities 
  validates :district_code, presence: true, if: :city_has_districts
  validates_format_of :phone, with: /\A[^a-zA-Z]*\z/

  def province_has_cities
    province_code.present? && Region.exists?(parent: province_code)
  end

  def city_has_districts
    city_code.present? && Region.exists?(parent: province_code)
  end

  def to_text
    "#{self.try(:province).try(:name)}#{self.try(:city).try(:name)}#{self.try(:district).try(:name)}"
  end
end
