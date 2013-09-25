class Section < ActiveRecord::Base
  validates_presence_of :title, :color
  has_many :posts
end
