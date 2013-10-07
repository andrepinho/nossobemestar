class Region < ActiveRecord::Base
  has_attached_file :background
  validates_presence_of :name, :subdomain
  has_many :posts
  has_many :sections, through: :posts
  def to_param
    "#{self.id}-#{self.name.parameterize}"    
  end
end
