# coding: utf-8
class Post < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "690x450>", :thumb => "200x200>" }
  validates_presence_of :title, :content, :author, :subtitle, :image_credit, :original_title
  validates_attachment :image, :presence => true, :content_type => { :content_type => /\Aimage\/.*\Z/ }
  belongs_to :section
  belongs_to :region
  has_many :likes, as: :likeable
  has_many :dislikes, as: :dislikeable

  include PgSearch::Model
  pg_search_scope :search, against: [
      [:title, 'A'],
      [:content, 'B'],
      [:front_title, 'B'],
      [:front_content, 'B'],
      [:subtitle, 'C'],
      [:author, 'C']
    ],
    using: {tsearch: {dictionary: "portuguese"}},
    ignoring: :accents

  multisearchable :against => [:title, :content, :front_title, :front_content, :subtitle, :author]

  def to_param
    "#{self.id}-#{self.original_title.parameterize}"
  end
  def self.visible
    where(["published_at <= ?", Time.now])
  end
  def self.highlighted
    visible.where("ordering IS NOT NULL").order(:ordering).limit(4)
  end
  def self.not_highlighted
    visible.where("ordering IS NULL")
  end
  def self.home_page
    visible.where("home_ordering IS NOT NULL").order(:home_ordering).limit(4)
  end
  def self.not_home_page
    visible.where("home_ordering IS NULL").order(:home_ordering).limit(4)
  end
end
