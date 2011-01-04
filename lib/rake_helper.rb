# To change this template, choose Tools | Templates
# and open the template in the editor.

def save_summaries(activity, model, conditions, save_attributes, save_values = nil)
  summary = model.find(:first, :conditions => conditions)

  if summary.nil?
    summary = model.new(
                          :minute => 0,
                          :minute_updated => Time.now.gmtime.strftime('%Y-%m-%dT%H:%MZ'),
                          :hour => 0,
                          :hour_updated => Time.now.gmtime.strftime('%Y-%m-%dT%H:00Z'),
                          :day => 0,
                          :day_updated => Time.now.gmtime.strftime('%Y-%m-%dT00:00Z'),
                          :week => 0,
                          :week_updated => Time.now.gmtime.strftime('%Y-%m-%dT00:00Z'),
                          :month => 0,
                          :month_updated => Time.now.gmtime.strftime('%Y-%m-01T00:00Z'),
                          :year => 0,
                          :year_updated => Time.now.gmtime.strftime('%Y-01-01T00:00Z'),
                          :all => 0)
    i = 0
    save_attributes.each do |attr|
      if save_values.nil?
        unless activity[attr].nil?
          summary[attr] = activity[attr]
        end
      else
        summary[attr] = save_values[i]
      end

      i += 1
    end
  else
    if summary.minute_updated < 1.minute.ago.gmtime
      summary.minute_updated = Time.parse(Time.now.gmtime.strftime('%Y-%m-%dT%H:%MZ'))
      summary.minute = 0
    end

    if summary.hour_updated < 1.hour.ago.gmtime
      summary.hour_updated = Time.parse(Time.now.gmtime.strftime('%Y-%m-%dT%H:00Z'))
      summary.hour = 0
    end

    if summary.day_updated < 1.day.ago.gmtime
      summary.day_updated = Time.parse(Time.now.gmtime.strftime('%Y-%m-%dT00:00Z'))
      summary.day = 0
    end

    if summary.week_updated < 1.week.ago.gmtime
      summary.week_updated = Time.parse(Time.now.gmtime.strftime('%Y-%m-%dT00:00Z'))
      summary.week = 0
    end

    if summary.month_updated < 1.month.ago.gmtime
      summary.month_updated = Time.parse(Time.now.gmtime.strftime('%Y-%m-01T00:00Z'))
      summary.month = 0
    end

    if summary.year_updated < 1.year.ago.gmtime
      summary.year_updated = Time.parse(Time.now.gmtime.strftime('%Y-01-01T00:00Z'))
      summary.year = 0
    end
  end

  summary.minute += 1
  summary.hour += 1
  summary.day += 1
  summary.week += 1
  summary.month += 1
  summary.year += 1
  summary.all += 1

  if summary.save
    return true
  else
    return false
  end
end