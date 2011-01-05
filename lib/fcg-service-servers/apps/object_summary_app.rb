module FCG::Service
  class ObjectSummaryApp < FCG::Service::Base
    get "/object_summaries/events" do
      case params[:order]
      when "hour":
        updated = 1.hour.ago.gmtime.strftime('%Y-%m-%dT%H:00Z')
        summaries = ObjectSummary.find(:all, :conditions => ["object_type = ? AND hour_updated >= ?", "event", updated], :order => params[:order]) rescue ""
      when "day":
        updated = 1.day.ago.gmtime.strftime('%Y-%m-%dT00:00Z')
        summaries = ObjectSummary.find(:all, :conditions => ["object_type = ? AND day_updated >= ?", "event", updated], :order => params[:order]) rescue ""
      when "week":
        updated = 1.week.ago.gmtime.strftime('%Y-%m-%dT00:00Z')
        summaries = ObjectSummary.find(:all, :conditions => ["object_type = ? AND week_updated >= ?", "event", updated], :order => params[:order]) rescue ""
      when "month":
        updated = 1.month.ago.gmtime.strftime('%Y-%m-01T00:00Z')
        summaries = ObjectSummary.find(:all, :conditions => ["object_type = ? AND month_updated >= ?", "event", updated], :order => params[:order]) rescue ""
      when "year":
        updated = 1.year.ago.gmtime.strftime('%Y-01-01T00:00Z')
        summaries = ObjectSummary.find(:all, :conditions => ["object_type = ? AND year_updated >= ?", "event", updated], :order => params[:order]) rescue ""
      else
        updated = 1.minute.ago.gmtime.strftime('%Y-%m-%dT%H:%MZ')
        summaries = ObjectSummary.find(:all, :conditions => ["object_type = ? AND minute_updated >= ?", "event", updated], :order => params[:order]) rescue ""
      end
      
      if summaries
        respond_with(summaries.map(&:to_hash))
      else
        error 404, respond_with("No summaries found")
      end
    end
  end
end