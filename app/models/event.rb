class Event < ActiveRecord::Base

  has_attached_file :image
  validates_presence_of :name, :starts_at, :ends_at, :description
  belongs_to :region

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def self.future
    where(["ends_at >= ?", Time.now])
  end

  def display_description
    self.description.gsub(/\n/, '<br/>').html_safe
  end

end
