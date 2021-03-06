module FCG::Service
  class TypeSummaryApp < FCG::Service::Base
    get "/type_summaries/types" do
      case params[:order]
      when "hour":
        updated = 1.hour.ago.gmtime.strftime('%Y-%m-%dT%H:00Z')
        summaries = TypeSummary.find(:all, :conditions => ["hour_updated >= ?", updated], :order => params[:order]) rescue ""
        LOGGER.info "Line 38 #{updated} " + summaries.length.to_s
      when "day":
        updated = 1.day.ago.gmtime.strftime('%Y-%m-%dT00:00Z')
        summaries = TypeSummary.find(:all, :conditions => ["day_updated >= ?", updated], :order => params[:order]) rescue ""
      when "week":
        updated = 1.week.ago.gmtime.strftime('%Y-%m-%dT00:00Z')
        summaries = TypeSummary.find(:all, :conditions => ["week_updated >= ?", updated], :order => params[:order]) rescue ""
      when "month":
        updated = 1.month.ago.gmtime.strftime('%Y-%m-01T00:00Z')
        summaries = TypeSummary.find(:all, :conditions => ["month_updated >= ?", updated], :order => params[:order]) rescue ""
      when "year":
        updated = 1.year.ago.gmtime.strftime('%Y-01-01T00:00Z')
        summaries = TypeSummary.find(:all, :conditions => ["year_updated >= ?", updated], :order => params[:order]) rescue ""
      else
        updated = 1.minute.ago.gmtime.strftime('%Y-%m-%dT%H:%MZ')
        summaries = TypeSummary.find(:all, :conditions => ["minute_updated >= ?", updated], :order => params[:order]) rescue ""
      end

      if summaries
        respond_with(summaries.map(&:to_hash))
      else
        error 404, respond_with("No summaries found")
      end
    end
  end
end