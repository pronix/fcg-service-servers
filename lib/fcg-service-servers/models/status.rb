class Status
  include FCG::Model
  
  field :user_id,           :type => String
  field :message,           :type => String
  field :message_as_html,   :type => String
  field :visible,           :type => Boolean, :default => true
  
  validates_presence_of :user_id
  validates_length_of :message, :in => 1..160
  before_save :htmlify
  
  def htmlify
    self.message_as_html = RDiscount.new(message, :autolink).to_html
  end
end