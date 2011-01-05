# raise "in here"
%W{ amqp aws mongodb redis }.each do |name|
  puts "shared_path:#{@shared_path}"
  puts "release_path:#{@release_path}"
  puts "name:#{name}"
  # run "ln -nfs #{@shared_path}/config/settings/#{name}.yml #{@release_path}/lib/fcg-service-servers/config/settings/#{name}.yml"
end