module FCG
  module Rest
    attr_accessor :model
    module ClassMethods
      def restful(*args)
        options = args.extract_options!
        opts = {
          :only => [:get, :post, :put, :delete],
          :search => false
        }.merge(options)
        klass = model.to_s.classify.constantize
        model_plural = model.to_s.pluralize
        str = <<-RUBY
          get "/#{model_plural}/:id" do
            begin
              #{model} = #{klass}.find(params[:id])
              if #{model}
                respond_with #{model}
              else
                error 404, respond_with("#{model} not found")
              end
            rescue BSON::InvalidObjectId => e
              error 404, respond_with("#{model} not found")
            end
          end if opts[:only].include? :get
          # create a new #{model}
          post "/#{model_plural}" do
            begin
              params = MessagePack.unpack(request.body.read)
              #{model} = #{klass}.new(params)
              if #{model}.valid? and #{model}.save
                respond_with #{model}
              else
                error 400, respond_with(error_hash(#{model}, "failed validation"))
              end
            rescue => e
              error 400, respond_with(e.message)
            end
          end if opts[:only].include? :post

          # update an existing #{model}
          put "/#{model_plural}/:id" do
            #{model} = #{klass}.find(params[:id])
            if #{model}
              begin
                #{model}.update_attributes(MessagePack.unpack(request.body.read))
                if #{model}.valid?
                  respond_with #{model}
                else
                  error 400, respond_with(error_hash(#{model}, "failed validation")) # do nothing for now. we'll cover later
                end
              rescue => e
                error 400, respond_with(e.message)
              end
            else
              error 404, respond_with("#{model} not found")
            end
          end if opts[:only].include? :put

          # destroy an existing #{model}
          delete "/#{model_plural}/:id" do
            #{model} = #{klass}.find(params[:id])
            if #{model}
              #{model}.destroy
              respond_with #{model}
            else
              error 404, respond_with("#{model} not found")
            end
          end if opts[:only].include? :delete
          
          post "/#{model_plural}/search" do
            begin
              query = params[:query]
              query.symbolize_keys!
              query_builder = Hashie::Clash.new
              # add limit
              query_builder.limit(query[:limit] || 10)
              # add offset
              query_builder.offset(query[:offset] || 0)
              # add fields that I want returned
              query_builder.only(query[:only]) if query[:only]
              # add where
              query_builder.where(query[:where]) if query[:where]
              results = #{klass}.find(query_builder)
              if results
                results.to_msgpack
              else
                error 404, "#{model_plural} not found".to_msgpack
              end
            rescue BSON::InvalidObjectId => e
              error 404, "#{model_plural} not found".to_msgpack
            end
          end if opts[:search]
        RUBY
        class_eval(str, __FILE__, __LINE__)
      end
      
      def model
        @model ||= self.to_s.split(/::/).last.sub(/App/, '').snakecase
      end
    end
    
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end