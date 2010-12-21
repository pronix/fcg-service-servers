module FCG::Service
  class RatingApp < FCG::Service::Base
    include FCG::Rest
    restful
    
    get "/ratings/record/:record" do
      begin
        if record_rating = RatingRecord.find_with_hashed_record(params[:record])
          respond_with(record_rating.to_hash)
        else
          respond_with({:average => 0, :count => 0, :record => params[:record]})
        end
      rescue Exception => e
        error 404, "record rating not found (#{e})".to_msgpack
      end
    end
  end
end