module FCG::Service
  class StatApp < FCG::Service::Base
    # get a stats by key
    get "/stats/:verb/:key/:time" do
      # /stats/view/image:4c4e7da0ff808d20c9000003/2010092614
      # count:view:image:4c4e7da0ff808d20c9000003:time:2010092614
      key = "count:#{params[:verb]}:#{params[:key]}:time:#{params[:time]}"
      begin
        value = REDIS.get key
        respond_with(value)
      rescue
        error 404, respond_with("key missing")
      end
    end
    
    # citycode || album || image
    get "/stats/rank/:verb/:rankable_key/:model/:time" do
      start = params[:start] || 0
      limit = params[:limit] || 10
      key = "rank:#{params[:verb]}:#{params[:rankable_key]}:model:#{params[:model]}:time:#{params[:time]}"
      begin
        value = REDIS.sort key, :limit => [ start, limit ], :by => "nosort"
        res = if value.respond_to? :map
          value.map{|k| [k, REDIS.zscore(key, k)]}.sort_by{|q| q.last.to_i }.reverse
        else
          []
        end
        respond_with(res)
      rescue Exception => e
        error 404, respond_with(e)
      end
    end
    
    get "/stats/most_visited" do
      start = params[:start] || 0
      limit = params[:limit] || 10
      begin
        res = []
        respond_with res
      rescue Exception => e
        error 404, respond_with(e)
      end
    end
  end
end

# http://onyi.local:5678/api/v1/stats/top/10/stats:view:model:event:citycode:nyc:day:2010-9-25
# 
# http://onyi.local:5678/api/v1/stats/:type/:model/:citycode/2010-9-25
# 
# rank:view:citycode:nyc:model:image:time:20100926
# /stats/rank/view/citycode:nyc/image/20100926
# http://onyi.local:5678/api/v1/stats/rank/citycode:nyc/view/event/20100925