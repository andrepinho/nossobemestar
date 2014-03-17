class Ad < ActiveRecord::Base
  has_attached_file :image, :styles => { :thumb => "220x600>" }
  validates_presence_of :code, :url
  validates_attachment :image, :presence => true, :content_type => { :content_type => "image/jpeg" }
  belongs_to :region
  belongs_to :section
  has_many :clicks
  before_validation :smart_add_url_protocol

  before_save do
    self.code.upcase!
  end

  def self.for(region, code, options = {})
    quantity = options[:quantity] || 1
    section = options[:section]
    if section
      ads_for = active.where(section_id: section.id, region_id: region.id, code: code.upcase).order('random()').limit(quantity)
      ads_for = fallback.where(section_id: section.id, region_id: region.id, code: code.upcase).order('random()').limit(quantity) if ads_for.empty?
      ads_for = active.where("region_id IS NULL").where(section_id: section.id, code: code.upcase).order('random()').limit(quantity) if ads_for.empty?
      ads_for = fallback.where("region_id IS NULL").where(section_id: section.id, code: code.upcase).order('random()').limit(quantity) if ads_for.empty?
      ads_for = active.where("region_id IS NULL AND section_id IS NULL").where(code: code.upcase).order('random()').limit(quantity) if ads_for.empty?
      ads_for = fallback.where("region_id IS NULL AND section_id IS NULL").where(code: code.upcase).order('random()').limit(quantity) if ads_for.empty?
    else
      ads_for = active.where(region_id: region.id, code: code.upcase).order('random()').limit(quantity)
      ads_for = fallback.where(region_id: region.id, code: code.upcase).order('random()').limit(quantity) if ads_for.empty?
      ads_for = active.where("region_id IS NULL").where(code: code.upcase).order('random()').limit(quantity) if ads_for.empty?
      ads_for = fallback.where("region_id IS NULL").where(code: code.upcase).order('random()').limit(quantity) if ads_for.empty?
    end
    return nil if ads_for.empty?
    return ads_for.first unless quantity > 1
    ads_for
  end

  def self.active
    where("starts_at < current_timestamp AND ends_at > current_timestamp")
  end

  def self.fallback
    where("starts_at IS NULL AND ends_at IS NULL")
  end

  def self.by_relevance
    order("region_id DESC, code, section_id, CASE WHEN ends_at >= current_timestamp THEN starts_at END ASC, CASE WHEN ends_at < current_timestamp THEN starts_at END DESC")
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
