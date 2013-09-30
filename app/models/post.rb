class Post < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "200x200>", :thumb => "100x100>" }
  validates_presence_of :title, :content, :author, :front_title, :front_content
  validates_attachment :image, :presence => true,
  :content_type => { :content_type => "image/jpeg" }
  belongs_to :section 
  belongs_to :region
  def to_param
    "#{self.id}-#{self.title.parameterize}"    
  end
end

