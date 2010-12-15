class Activity < SimpleRecord::Base
  include FCG::SimpleDB
  
  # [actor] [verb] [object] [target]
  has_strings :user_id
  has_strings :verb
  has_strings :object_type, :object_id
  has_strings :target
  has_strings :title
  has_strings :page
  has_strings :site
  has_strings :city
  has_strings :extra
  
  #validates_presence_of :actor, :object, :verb, :title
  # validates_inclusion_of :verb, :within => FCG::ACTIVITY::VERBS::ALL.keys.map(&:to_s)

#  class << self
#    def visited_page(*args)
#      opts = args.extract_options!
#      create({
#        :user_id => opts[:user_id],
#        :site => SITE["name"],
#        :path => opts[:path], #album/Event/4c442ae8ff808daa0f000002/photos/4c4e7da0ff808d20c9000003
#        :extra => opts[:extra] || {}
#      })
#    end
#
#    def most_visited_paths(path, *args)
#      options = args.extract_options!
#      now = Time.now.utc
#
#      opts = {
#        :limit => 10,
#        :date_range => 7.days.ago(now)..now,
#        :key => [:path, :extra],
#        :condition => lambda{|date| {"path" => /^#{path}/i, "created_at" => { "$gte" => date.first, "$lt" => date.last } } },
#        :initial => {"count" => 0},
#        :reduce => "function(obj,prev){ prev.count++; }",
#        :finalize => nil
#      }.merge(options)
#
#      date_range = case options[:date_range]
#      when "24hrs"
#        1.day.ago(now)..now
#      when "1week"
#        7.days.ago(now)..now
#      when "1hr"
#        1.hour.ago(now)..now
#      else
#        opts[:date_range]
#      end
#
#      condition = begin
#        if opts[:condition].respond_to? :call
#          opts[:condition].call(date_range)
#        else
#          opts[:condition]
#        end
#      end
#
#      self.collection.group(
#        opts[:key],
#        condition,
#        opts[:initial],
#        opts[:reduce],
#        opts[:finalize]
#      )
#    end
#
#    def most_visited_albums(*args)
#      res = self.most_visited_paths(*args)
#      res.sort!{|a,b| b["count"]<=>a["count"]}
#      res.inject(ActiveSupport::OrderedHash.new) do |sum, r|
#        i = r["path"].split('/')
#        model, id, album_type, image_id = i[2..5]
#        sum[image_id] = {
#          :count => r["count"],
#          :model => model,
#          :id => id,
#          :image_id => image_id,
#          :album_type => album_type,
#          :citycode => r["extra"]["citycode"]
#        }
#        sum
#      end if res.respond_to? :inject
#    end
#
#    def most_visited_album_photos_by_citycode(citycode, *args)
#      options = args.extract_options!
#      path = "/album/event"
#      options[:condition] = lambda{|date| {"$where" => "this.extra.citycode == '#{citycode}';", "path" => /^#{path}/i, "created_at" => { "$gte" => date.first, "$lt" => date.last } } }
#      self.most_visited_albums(path, options)
#    end
#
#    def most_visited_album_photos_by_site(site, *args)
#      options = args.extract_options!
#      path = "/album/event"
#      options[:condition] = lambda{|date| {"site" => site, "path" => /^#{path}/i, "created_at" => { "$gte" => date.first, "$lt" => date.last } } }
#      self.most_visited_albums(path, options)
#    end
#  end
end