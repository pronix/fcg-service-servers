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
          get "/#{model_plural}/search" do
            begin
              # params = payload
              query = params
              query_builder = Hashie::Clash.new
              # add limit
              query_builder.limit(query[:limit].to_i || 10)
              # add skip aka offset
              query_builder.skip(query[:skip].to_i || 0)
              # add fields that I want returned
              query_builder.only(query[:only]) if query[:only]
              # add where
              query_builder.conditions(query[:conditions]) if query[:conditions]
              
              results = #{klass}.find(query_builder)
              if results.size > 0
                respond_with(results.map(&:to_hash))
              else
                respond_with([])
                # error 404, respond_with("#{model_plural} not found")
              end
            rescue BSON::InvalidObjectId => e
              LOGGER.error "\#{e.backtrace}: \#{e.message} (\#{e.class})"
              error 404, respond_with("#{model_plural} not found")
            end
          end if opts[:search]
        
          get "/#{model_plural}/:id" do
            begin
              #{model} = #{klass}.find(params[:id])
              if #{model}
                respond_with #{model}
              else
                error 404, respond_with("#{model} not found")
              end
            rescue BSON::InvalidObjectId => e
              LOGGER.error "\#{e.backtrace}: \#{e.message} (\#{e.class})"
              error 404, respond_with("#{model} not found")
            end
          end if opts[:only].include? :get
          # create a new #{model}
          post "/#{model_plural}" do
            begin
              params = payload
              LOGGER.info "payload:\#{payload.inspect}"
              #{model} = #{klass}.new(params)
              LOGGER.info "#{model}:" + params.inspect
              if #{model}.valid? and #{model}.save
                respond_with #{model}
              else
                error 400, respond_with(error_hash(#{model}, "failed validation"))
              end
            rescue Exception => e
              LOGGER.error "\#{e.backtrace}: \#{e.message} (\#{e.class})"
              error 400, respond_with(e.message)
            end
          end if opts[:only].include? :post

          # update an existing #{model}
          put "/#{model_plural}/:id" do
            #{model} = #{klass}.find(params[:id])
            if #{model}
              begin
                LOGGER.info "payload:\#{payload.inspect}"
                #{model}.update_attributes(payload)
                if #{model}.valid?
                  respond_with #{model}
                else
                  error 400, respond_with(error_hash(#{model}, "failed validation")) # do nothing for now. we'll cover later
                end
              rescue => e
                LOGGER.error "\#{e.backtrace}: \#{e.message} (\#{e.class})"
                error 404, respond_with(e.message)
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