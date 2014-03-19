class Ad < ActiveRecord::Base
  has_attached_file :image, :styles => { :thumb => "220x600>" }
  belongs_to :region
  belongs_to :section
  belongs_to :event
  belongs_to :service
  has_many :clicks
  validates_presence_of :code
  validates_presence_of :url, if: Proc.new { |ad| !['DA', 'DG'].include?(ad.code) }
  validates_presence_of :image, if: Proc.new { |ad| !['DA', 'DG'].include?(ad.code) }
  validates_attachment :image, :content_type => { :content_type => /\Aimage\/.*\Z/ }
  validates_presence_of :event, if: Proc.new { |ad| ad.code == 'DA' }
  validates_presence_of :service, if: Proc.new { |ad| ad.code == 'DG' }
  validates_presence_of :section, if: Proc.new { |ad| ["H", "H2", "C", "C2", "DC", "S", "S2", "DS"].include?(ad.code) }
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
