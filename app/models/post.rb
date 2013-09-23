class Post < ActiveRecord::Base
  validates_presence_of :title, :content, :author
  belongs_to :section 
  belongs_to :region
end
