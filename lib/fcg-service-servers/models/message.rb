class Message
  include FCG::Model
  # is_paranoid
  
  field :sender_id,             :type => String
  field :receiver_id,           :type => String
  field :body,                  :type => String
  field :body_as_html,          :type => String
  field :viewable_by_sender,    :type => Boolean, :default => true
  field :viewable_by_receiver,  :type => Boolean, :default => true
  
  validates_presence_of :sender_id, :receiver_id
  validates_length_of :body, :in => 1..25000
  before_save :htmlify
  
  def htmlify
    self.body_as_html = RDiscount.new(body, :autolink).to_html
  end
end