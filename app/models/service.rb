class Service < ActiveRecord::Base

  has_attached_file :image
  validates_presence_of :name, :description
  belongs_to :region

  geocoded_by :full_address
  after_validation :geocode

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

  def display_description
    self.description.gsub(/\n/, '<br/>').html_safe
  end

  def full_address
    return self.address unless self.region and not self.address.match(/#{self.region.name}/i)
    "#{self.address} #{self.region.name}".strip
  end

end
