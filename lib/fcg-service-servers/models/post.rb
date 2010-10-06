class Post
  include FCG::Model
  is_versioned
  is_paranoid
  
  field :site,          :type => String
  field :title,         :type => String
  field :body,          :type => String
  field :body_html,     :type => String
  field :username,      :type => String
  field :display_name,  :type => String
  field :feed_id,       :type => String
  field :user_id,       :type => String

  validates_presence_of :site, :title, :user_id, :body, :display_name, :username
  validates_length_of :title, :within => 3..64
  validates_length_of :body, :within => 3..10000
  before_create :htmlify
  
  def htmlify
    self.body_html = RDiscount.new(body, :smart, :autolink).to_html
  end
end