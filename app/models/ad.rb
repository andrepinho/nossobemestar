class Ad < ActiveRecord::Base
  has_attached_file :image
  validates_presence_of :region, :code, :image, :url
  belongs_to :region
  before_validation :smart_add_url_protocol

  before_save do
    self.code.upcase!
  end

  def self.by_relevance
    order("CASE WHEN ends_at >= current_timestamp THEN starts_at END ASC, CASE WHEN ends_at < current_timestamp THEN starts_at END DESC")
  end

  def smart_add_url_protocol
    if self.url.present? && !url_protocol_present?
      self.url = "http://#{self.url}"
    end
  end

  def url_protocol_present?
    self.url[/^http:\/\//] || self.url[/^https:\/\//]
  end

end
