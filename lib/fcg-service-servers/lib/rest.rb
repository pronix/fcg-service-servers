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
              #{model}.to_msgpack
            else
              error 404, "#{model} not found".to_msgpack
            end
          end if opts[:actions].include? :get
          # create a new #{model}
          post "/api/#{API_VERSION}/#{model_plural}" do
            begin
              params = MessagePack.unpack(request.body.read)
              #{model} = #{klass}.new(params)
              if #{model}.valid? and #{model}.save
                #{model}.to_msgpack
              else
                error 400, error_hash(#{model}, "failed validation").to_msgpack
              end
            rescue => e
              error 400, e.message.to_msgpack
            end
          end if opts[:actions].include? :post

          # update an existing #{model}
          put "/api/#{API_VERSION}/#{model_plural}/:id" do
            #{model} = #{klass}.find(params[:id])
            if #{model}
              begin
                #{model}.update_attributes(MessagePack.unpack(request.body.read))
                if #{model}.valid?
                  #{model}.to_msgpack
                else
                  error 400, error_hash(#{model}, "failed validation").to_msgpack # do nothing for now. we'll cover later
                end
              rescue => e
                error 400, e.message.to_msgpack
              end
            else
              error 404, "#{model} not found".to_msgpack
            end
          end if opts[:actions].include? :put

          # destroy an existing #{model}
          delete "/api/#{API_VERSION}/#{model_plural}/:id" do
            #{model} = #{klass}.find(params[:id])
            if #{model}
              #{model}.destroy
              #{model}.to_msgpack
            else
              error 404, "#{model} not found".to_msgpack
            end
          end if opts[:actions].include? :delete
        RUBY
        class_eval(str, __FILE__, __LINE__)
      end
    end
    
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end