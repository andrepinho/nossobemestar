# coding: utf-8
class Post < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "472x314>", :thumb => "100x100>" }
  validates_presence_of :title, :content, :author, :front_title, :front_content, :image_credit
  validates_attachment :image, :presence => true,
  :content_type => { :content_type => "image/jpeg" }
  belongs_to :section
  belongs_to :region

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end
  def self.visible
    where(["published_at <= ?", Time.now])
  end
  def self.highlighted
    visible.where("ordering IS NOT NULL").order(:ordering).limit(4)
  end
  def self.unhighlighted
    visible.where("ordering IS NULL")
  end
  def self.home_page
    visible.where("home_ordering IS NOT NULL").order(:home_ordering).limit(4)
  end
end
