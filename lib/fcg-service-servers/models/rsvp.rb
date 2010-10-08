class Rsvp
  include FCG::Model
  
  field :user_id,           :type => String
  field :name,              :type => String
  field :email,             :type => String
  field :phone,             :type => String
  field :occassion,         :type => String
  field :number_of_guests,  :type => Integer
  field :bottle_service,    :type => Boolean
  field :message,           :type => String
  
  validates_presence_of :name, :number_of_guests
  validates_length_of :message, :allow_nil => true, :in => 1..1000
end