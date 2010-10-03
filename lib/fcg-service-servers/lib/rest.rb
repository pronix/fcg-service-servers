module FCG
  module Rest
    def self.restful(model, app_class, *args)
      options = args.extract_options!
      klass = model.to_s.classify.constantize
      model_plural = model.to_s.pluralize
      str = <<-RUBY
        get "/api/#{API_VERSION}/#{model_plural}/:id" do
          #{model} = #{klass}.find(params[:id]) rescue nil
          if #{model}
            #{model}.to_json
          else
            error 404, "#{model} not found".to_json
          end
        end
        # create a new #{model}
        post "/api/#{API_VERSION}/#{model_plural}" do
          begin
            params = JSON.parse(request.body.read)
            #{model} = #{klass}.new(params)
            if #{model}.valid? and #{model}.save
              #{model}.to_json
            else
              error 400, error_hash(#{model}, "failed validation").to_json
            end
          rescue => e
            error 400, e.message.to_json
          end
        end
      
        # update an existing #{model}
        put "/api/#{API_VERSION}/#{model_plural}/:id" do
          #{model} = #{klass}.find(params[:id])
          if #{model}
            begin
              #{model}.update_attributes(JSON.parse(request.body.read))
              if #{model}.valid?
                #{model}.to_json
              else
                error 400, error_hash(#{model}, "failed validation").to_json # do nothing for now. we'll cover later
              end
            rescue => e
              error 400, e.message.to_json
            end
          else
            error 404, "#{model} not found".to_json
          end
        end
      
        # destroy an existing #{model}
        delete "/api/#{API_VERSION}/#{model_plural}/:id" do
          #{model} = #{klass}.find(params[:id])
          if #{model}
            #{model}.destroy
            #{model}.to_json
          else
            error 404, "#{model} not found".to_json
          end
        end
      RUBY
      app_class.class_eval(str, __FILE__, __LINE__)
    end
  end
end