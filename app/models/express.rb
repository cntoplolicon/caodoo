class Express < ActiveRecord::Base
  validates :name, presence: true
  validates :code, presence: true

  default_scope { where(deleted: false) }
end