module FCG
  module Rest
    module ClassMethods
      def rest(model, *args)
        options = args.extract_options!
        opts = {
          :actions => [:get, :post, :put, :delete]
        }.merge(options)
        
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
          end if opts[:actions].include? :get
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
          end if opts[:actions].include? :post

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
          end if opts[:actions].include? :put

          # destroy an existing #{model}
          delete "/api/#{API_VERSION}/#{model_plural}/:id" do
            #{model} = #{klass}.find(params[:id])
            if #{model}
              #{model}.destroy
              #{model}.to_json
            else
              error 404, "#{model} not found".to_json
            end
          end if opts[:actions].include? :delete
        RUBY
        class_eval(str, __FILE__, __LINE__)
      end
    end
    
    def self.included(receiver)
      receiver.extend ClassMethods
      @klass = receiver
    end
  end
end