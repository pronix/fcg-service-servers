module FCG::Service
  class RatingApp < FCG::Service::Base
    include FCG::Rest
    restful
    
    get "/ratings/record/:record" do
      begin
        record_rating = RatingRecord.find_with_hashed_record(params[:record])
        if record_rating
          record_rating.to_msgpack
        else
          error 404, "record rating not found".to_msgpack
        end
      rescue Exception => e
        error 404, "record rating not found (#{e})".to_msgpack
      end
    end
  end
end