module ApplicationHelper
  DAYS = Array['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
  def show_day_of_week(day)
    DAYS[day]
  end

  def boolean_text(b)
    b ? '是' : '否'
  end
end
