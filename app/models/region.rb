class Region < ActiveRecord::Base
  validates_presence_of :name, :subdomain
  has_many :posts
  def to_param
    "#{self.id}-#{self.name.parameterize}"    
  end
end
