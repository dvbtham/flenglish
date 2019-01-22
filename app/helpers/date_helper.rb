module DateHelper
  def weekly
    (Date.today.at_beginning_of_week..Date.today.at_end_of_week).map
  end

  def month_begin
    Date.new Date.today.year, Date.today.month
  end
end
