class Post < ActiveRecord::Base
  validates_presence_of :title, :content, :author, :front_title, :front_content, :priority
  belongs_to :section 
  belongs_to :region
end
