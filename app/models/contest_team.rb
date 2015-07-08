class ContestTeam < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password
  validates_format_of :password, with: /\A[ -~]{6,20}\z/

  def level
    Settings.contest.level_exp.each_with_index do |exp, i|
      return i - 1 if sales_quantity < exp
    end
    Settings.contest.level_exp.length - 1
  end
end
