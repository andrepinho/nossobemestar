#coding: utf-8

class Dislike < ActiveRecord::Base
  belongs_to :dislikeable, polymorphic: true
  belongs_to :user
  validates_presence_of :dislikeable, :user
  validates :user_id, :uniqueness => { :scope => [:dislikeable_type, :dislikeable_id] }
end
