class Service < ActiveRecord::Base

  has_attached_file :image
  before_validation :smart_add_url_protocol
  validates_presence_of :name, :image, :description
  belongs_to :region
  belongs_to :user
  validates_attachment :image, :content_type => { :content_type => /\Aimage\/.*\Z/ }
  validates :image, :minimum_dimensions => { :width => 200, :height => 200 }

  geocoded_by :address do |object, results|
    if geo = results.first
      object.latitude = geo.latitude
      object.longitude = geo.longitude
      object.postal_code = geo.postal_code
    end
  end
  after_validation :geocode

  include PgSearch::Model
  pg_search_scope :search, against: [
      [:name, 'A'],
      [:description, 'B'],
      [:address, 'C']
    ],
    using: {tsearch: {dictionary: "portuguese"}},
    ignoring: :accents

  multisearchable :against => [:name, :description, :address]

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

  def smart_add_url_protocol
    if self.url.present? && !url_protocol_present?
      self.url = "http://#{self.url}"
    end
  end

  def url_protocol_present?
    self.url[/^http:\/\//] || self.url[/^https:\/\//]
  end

  def self.to_csv
    columns = ["id", "name", "address", "url", "email", "phone_number", "postal_code"]
    CSV.generate do |csv|
      csv << columns
      all.each do |row|
        csv << columns.map { |column| row.send(column) }
      end
    end
  end

end
