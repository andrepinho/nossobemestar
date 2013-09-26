class Region < ActiveRecord::Base
  validates_presence_of :name, :subdomain
  has_many :posts
end
