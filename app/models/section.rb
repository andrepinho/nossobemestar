class Section < ActiveRecord::Base
  validates_presence_of :name, :color
  has_many :posts
end
