# coding: utf-8
class Event < ActiveRecord::Base

  has_attached_file :image
  before_validation :smart_add_url_protocol
  validates_presence_of :name, :image, :starts_at, :ends_at, :description
  belongs_to :region
  belongs_to :user
  validates_attachment :image, :content_type => { :content_type => /\Aimage\/.*\Z/ }
  validates :image, :minimum_dimensions => { :width => 200, :height => 200 }

  geocoded_by :address
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

  def self.not_past
    where("starts_at >= current_timestamp")
  end

  def self.by_relevance
    order("CASE WHEN starts_at >= current_timestamp THEN starts_at END ASC, CASE WHEN starts_at < current_timestamp THEN starts_at END DESC")
  end

  def display_description
    self.description.gsub(/\n/, '<br/>').html_safe
  end

  def past?
    starts_at < Time.now
  end

  def ongoing?
    starts_at < Time.now && ends_at > Time.now
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
    columns = ["id", "name", "starts_at", "ends_at", "address", "url", "email", "phone_number"]
    CSV.generate do |csv|
      csv << columns
      all.each do |row|
        csv << columns.map { |column| row.send(column) }
      end
    end
  end

end
