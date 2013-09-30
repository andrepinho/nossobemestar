class Post < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_presence_of :title, :content, :author, :front_title, :front_content
  validates_attachment :image, :presence => true,
  :content_type => { :content_type => "image/jpg" }
  belongs_to :section 
  belongs_to :region
end

