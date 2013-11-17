class Event < ActiveRecord::Base

  has_attached_file :image
  validates_presence_of :name, :starts_at, :ends_at, :description
  belongs_to :region

  include PgSearch
  pg_search_scope :search, against: [
      [:name, 'A'],
      [:description, 'B'],
      [:address, 'C']
    ],
    using: {tsearch: {dictionary: "portuguese"}},
    ignoring: :accents

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def self.by_relevance
    order("CASE WHEN ends_at >= current_timestamp THEN starts_at END ASC, CASE WHEN ends_at < current_timestamp THEN starts_at END DESC")
  end

  def display_description
    self.description.gsub(/\n/, '<br/>').html_safe
  end

  def past?
    ends_at < Time.now
  end

  def coordinates
    Geocoder.coordinates("#{self.address} #{self.region.name if self.region}")
  end

  def latitude
    self.coordinates[0] if self.coordinates
  end

  def longitude
    self.coordinates[1] if self.coordinates
  end

end
