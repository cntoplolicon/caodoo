class ContestTeam < ActiveRecord::Base
  attr_accessor :updating_password

  before_save :normalize_blank_values

  has_secure_password
  validates_presence_of :name
  validates_presence_of :phone
  validates_presence_of :contacts
  validates_presence_of :identifier
  validates_presence_of :password, if: :should_validate_password?
  validates_format_of :password, with: /\A[ -~]{6,20}\z/, if: :should_validate_password?

  def level
    Settings.contest.level_exp.each_with_index do |exp, i|
      return i - 1 if sales_quantity < exp
    end
    Settings.contest.level_exp.length - 1
  end

  def should_validate_password?
    updating_password || new_record?
  end

  def normalize_blank_values
    attributes.each do |column, value|
      if self[column] == ""
        self[column] = nil
      end
    end
  end
end
