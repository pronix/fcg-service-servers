module FCG
  module Client
    # namespace our plugin and inherit from Rails::Railtie to get our plugin into the initialization process
    class Railtie < Rails::Railtie
      # configure our plugin on boot. other extension points such as configuration, rake tasks, etc, are also available
      initializer "fcg.client.initialize" do |app|
        # subscribe to all rails notifications: controllers, AR, etc.
        ActiveSupport::Notifications.subscribe do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          puts "Got notification: #{event.inspect}"
        end
      end
    end
  end
end