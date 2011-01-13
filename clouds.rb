require "poolparty"
pool :fcg do
  cloud :service do
    using :ec2
    user "ubuntu"
    image_id "ami-a6f504cf" #ccf405a5 #19a34270
    keypair "~/.ssh/akuja-keypair"
    instances 1..2
    s3_url "fcgmedia"
    access_key ENV["AWS_ACCESS_KEY"]
    secret_access_key ENV["AWS_SECRET_ACCESS_KEY"]
    security_group do
      %w(22 80 443).each {|port|  authorize :from_port => port, :to_port => port}
    end
    # ebs_volumes do # https://github.com/joemocha/poolparty/blob/master/lib/cloud_providers/ec2/ec2.rb#L439
    #   volumes "vol-1cf65674"
    #   device "/dev/sda3"
    #   size 15
    # end
    
    chef :solo do
      repo File.dirname(__FILE__)+"/chef-repo"
      attributes({
        :instance_role => "solo",
        :name => "fcg_service",
        :owner_name => "app", # for mongodb
        :server_name => "service.fcgmedia.com",
        :ruby_version => "ruby-1.8.7-p330",
        :mongodb_version => "1.6.5",
        :aws => {
          :access_key => ENV["AWS_ACCESS_KEY"],
          :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]
        },
        :hostname => "service.fcgmedia.com",
        :server_aliases => 0.upto(5).map{|i| "service-#{i}.fcgmedia.com" },
        :thin => {
          :server_size => 5
        },
        :monit => {
          :apps => [:thin]
        },
        :memcached => {
          :memory => 128
        },
        :active_applications => [:fcg_service],
        :active_groups => ["deploy", "app"],
        :active_users => ["deploy", "app"],
        :ssh_keys => {
          :app    => "#{ENV['SSH_RSA_KEY']} app@service.fcgmedia.com",
          :deploy => "#{ENV['SSH_RSA_KEY']} deploy@service.fcgmedia.com"
        },
        :users => {
          :deploy => {
            :comment => "Deploy User",
            :groups => ["deploy"],
            :password => "$1$VO6mVOAd$I2ceD83x5uaQZk3OshbZ51"
          },
          :app => {
            :comment => "App User",
            :groups => ["app", "deploy"],
            :password => "$1$VO6mVOAd$I2ceD83x5uaQZk3OshbZ51" # echo "PASSWORD" | makepasswd --clearfrom=- --crypt-md5 |awk '{ print $2 }'
          }
        },
        :groups => {
          :deploy => {
            :gid => 5000
          },
          :app => {
            :gid => 6000, 
          } 
        },
        :sudo => {
          :users  => ["deploy", "ubuntu"],
          :groups => ["deploy", "ubuntu", "admin"]
        }
      })
      %W{monit fcg_service}.each do |r| # build-essential ubuntu rubygems ruby-shadow quick_start ntp mongodb gems ssh_keys sudo nginx 
        recipe r
      end
    end
    
    # autoscale do
    #   trigger :lower_threshold => 0.3, :upper_threshold => 1.0, :measure => :cpu
    # end
    # security_group do
    #   authorize :from_port => 22, :to_port => 22
    # end
    # load_balancer do
    #   listener :external_port => 8080, :internal_port => 8080, :protocol => 'tcp'
    # end
  end
end
