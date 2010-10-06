class Comment
  include FCG::Model
  scope :threaded_with_field_sorted_by_votes, lambda {|tid| where(:model_with_id => tid).sort(['path','ascending'], ['net_votes', 'descending']) }
  
  field :site,            :type => String 
  field :model_with_id,   :type => String #format model:id
  field :body,            :type => String 
  field :body_html,       :type => String 
  field :deleted,         :type => Boolean
  field :flagged_by,      :type => Array
  field :depth,           :type => Integer, :default => 0
  field :path,            :type => String,  :default => ""
  field :parent_id,       :type => String
  field :displayed_name,  :type => String,  :default => 'Anonymous Coward'
  field :user_id,         :type => String
  
  validates_presence_of :site, :model_with_id, :body, :displayed_name, :user_id
  validates_length_of :body,   :within => 3..3000

  # Callbacks.
  before_create :htmlify
  after_create :set_path
  
  class << self
    # Return an array of comments, threaded, from highest to lowest votes.
    # Sorts by votes descending by default, but could use any other field.
    # If you want to build out an internal balanced score, pass that field in,
    # and be sure to index it on the database.
    def threaded_with_field(model_with_id, field_name='net_votes')
      comments = threaded_with_field_sorted_by_votes(model_with_id).all
      results, map  = [], {}
      comments.each do |comment|
        if comment.parent_id.blank?
          results << comment
        else
          comment.path =~ /:([\d|\w]+)$/
          if parent = $1
            map[parent] ||= []
            map[parent] << comment
          end
        end
      end
      assemble(results, map)
    end

    # Used by Comment#threaded_with_field to assemble the results.
    def assemble(results, map)
      list = []
      results.each do |result|
        if map[result.id.to_s]
          list << result
          list += assemble(map[result.id.to_s], map)
        else
          list << result
        end
      end
      list
    end
  end

  # Is this a root node?
  def root?
    self.depth.zero?
  end

  def htmlify
    self.body_html = RDiscount.new(body, :smart, :autolink).to_html
  end

  private
  # Store the comment's path.
  def set_path
    unless self.parent_id.blank?
      parent              = self.class.find(self.parent_id)
      self.model_with_id = parent.model_with_id
      self.depth          = parent.depth + 1
      self.path           = parent.path + ":" + parent.id.to_s
    end
    save
  end
end