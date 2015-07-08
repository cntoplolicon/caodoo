class Region < ActiveRecord::Base
  belongs_to :parent_region, class_name: 'Region', foreign_key: 'parent', primary_key: 'code', inverse_of: :sub_regions
  has_many :sub_regions, class_name: 'Region', foreign_key: 'parent', primary_key: 'code', inverse_of: :parent_region

  def disabled_self?
    self.disabled
  end

  def disabled_hierachy?
    e = self
    while e.present? do
      if e.disabled
        return true
      end
      e = e.parent_region
    end
    false
  end
end
