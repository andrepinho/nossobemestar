class Region < ActiveRecord::Base
  has_attached_file :background
  validates_presence_of :name, :subdomain
  has_many :posts
  has_many :sections, through: :posts
  has_many :events
  has_many :services
  has_many :users

  reverse_geocoded_by :latitude, :longitude

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def self.closest_to(coordinates)
    near(coordinates, 1000, units: :km).limit(1).first
  end

end
