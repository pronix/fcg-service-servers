raise "in here"
%W{ ampq app aws mongodb redis }.each do |name|
  run "ln -nfs #{shared_path}/config/settings/#{name}.yml #{release_path}/lib/fcg-service-servers/config/settings/#{name}.yml"
end