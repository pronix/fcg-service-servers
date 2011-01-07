class Bookmark
  include FCG::Model
  
  scope :by_user, lambda { |user_id| where(:user_id => user_id) }
  scope :by_type, lambda { |type| where("extra.type" => type) }
  
  field :user_id,       :type => String
  field :title,         :type => String
  field :path,          :type => String
  field :bookmark_type,          :type => String
  
  validates_presence_of :user_id, :title, :path, :bookmark_type

  def save
    bookmark = Bookmark.find(:first, :conditions => {:user_id => self.user_id, :path => self.path})

    if bookmark.nil?
      super
    else
      self.id = bookmark.id
      super
    end
  end
end