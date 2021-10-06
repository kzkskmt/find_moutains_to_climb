module ApplicationHelper
  def hhmm(min)
    min_i = min.to_i
    hours = min_i / 60
    mins = min_i - hours * 60
    mins.zero? ? format('%d時間', hours) : format('%d時間%02d分', hours, mins)
  end
end
