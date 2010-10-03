Fabricator :activity do
  actor do
    {
      :display_name => "Paul Dix",
      :url => "http://www.fcgid.com/person/paulDiddy", 
      :photo => nil
    }
  end
  target do
    {
      :title => "in the photo album (Mon, Jul 19: Salladin at Marquee (Solid))",
      :thumbnail => "http://destroy_later_blah_blah_blah.s3.amazonaws.com/alltheparties.com//cd772554-d709-988a-2472-cdd9b5a7a96d/00-thumb.jpg",
      :album_page_url => "/album/Event/4c442ae8ff808daa0f000002/photos",
      :id => "event:4c442ae8ff808daa0f000002" 
    }
  end
  object do
    {
      :title => "a photo",
      :image_page_url => "/album/Event/4c442ae8ff808daa0f000002/photos/4c4e81c7ff808d20c9000005",
      :id => "image:4c4e81c7ff808d20c9000005",
      :description => "Standing on the stage Club Space WMC 2001",
      :larger_image => "http://destroy_later_blah_blah_blah.s3.amazonaws.com/alltheparties.com//df39e4f8-6944-5d8f-d91f-843620c762f5/P3266699-medium.jpg"
    }
  end
  verb    "view"
  title   "Paul Dix viewed a photo in Rip's Photo Album"
  site    "alltheparties.com"
  visible false
end