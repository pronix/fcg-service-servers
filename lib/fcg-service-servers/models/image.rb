class Image
  include FCG::Model
  
  field :caption,   :type => String
  field :types,     :type => Array
  field :urls,       :type => Hash
  field :sizes,      :type => Hash
  field :user_id,   :type => String
  field :album_id,  :type => String
  
  validates_presence_of :user_id, :types, :album_id, :urls, :sizes
     
  def sizes
    types.map{|t| FCG_CONFIG[:image][:sizes][t] }
  end
end