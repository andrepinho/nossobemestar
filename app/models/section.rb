class Section < ActiveRecord::Base
  validates_presence_of :name, :color
  has_many :posts
  def to_param
    "#{self.id}-#{self.name.parameterize}"    
  end
end
